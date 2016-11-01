# Original from http://snippets.dzone.com/posts/show/4468 by MichaelBoutros
#
# Optimized version which uses to_yaml for content creation and checks
# that models are ActiveRecord::Base models before trying to fetch
# them from database.

# Then forked from https://gist.github.com/iiska/1527911
#
# fixed obsolete use of RAILS_ROOT, glob
# allow to specify output directory by FIXTURES_PATH

namespace :db do
  namespace :fixtures do
    desc 'Dumps all models into fixtures.'
    task :dump => :environment do
      models = Dir.glob(Rails.root + 'app/models/**.rb').map do |s|
        Pathname.new(s).basename.to_s.gsub(/\.rb$/,'').camelize
      end
      # specify FIXTURES_PATH to test/fixtures if you do test:unit
      dump_dir = ENV['FIXTURES_PATH'] || "test/fixtures/"

      # add '/'' to end of dir if it does not exist
      dump_dir += '/' if ! "/\\".include?(dump_dir[dump_dir.size-1])

      entry_size = ENV['ENTRY_SIZE'] || 10
      puts "Found models: " + models.join(', ')
      puts "Dumping to: " + dump_dir

      models.each do |m|
        model = m.constantize
        next unless model.ancestors.include?(ActiveRecord::Base)

        #entries = model.unscoped.all.order('id ASC')
        # retrieve only first X entries from the database - Yong
        entries = model.unscoped.order('id ASC').limit(entry_size)
        puts "Dumping model: #{m} (#{entries.length} entries)"

        increment = 1

        # use test/fixtures if you do test:unit
        model_file = Rails.root + (dump_dir + m.underscore.pluralize + '.yml')
        output = {}
        entries.each do |a|
          attrs = a.attributes
          puts "Model is: #{m}\n"
          
          #attrs.delete_if{|k,v| v.nil?}

          # do not export created_at, updated_at and null value fields
          #attrs.delete_if{|k,v| v.nil? || (k == "created_at" || k == "updated_at")}
          attrs.delete_if{|k,v| (k == "created_at" || k == "updated_at")}

          attrs= fix_referential_foerien_key(attrs, entry_size.to_i)

          output["#{m}_#{increment}"] = attrs

          increment += 1
        end
        file = File.open(model_file, 'w')
        file << output.to_yaml
        file.close #better than relying on gc
      end

    end

    def fix_referential_foerien_key(atrs, entry_size)

      puts "Before replace, attrs is: #{atrs}\n"
      #puts "Attrs class is #{atrs.class}\n"

      # loop through the keys and find its foreign key reference, 
      # replace its value if the value is out of range
      atrs.update(atrs) do |key, val|

        # find foreign reference key
        if key.include?("_id") #and ! ["product_id"].include? key
          #puts "Found XXX_id key: #{key}, value: #{val}"
          val = rand(1..entry_size) if (val.is_a? Numeric and val > entry_size) or (val.nil?)
        end

        val

      end

      puts "After replace, attrs is: #{atrs}\n"

      return atrs
      
    end

  end
end
