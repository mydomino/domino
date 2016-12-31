namespace :cc do



	desc 'reset_organization_counter_cache'
  task reset_organization_counter_cache: :environment do

    # Resets all the cached information about columns, which will 
    # cause them to be reloaded on the next request.
    Organization.reset_column_information

    Organization.find_each do |p|

    	puts "Reseting counter cache for organization #{p.name}..."

    	# Resets user counter caches to its correct value using an SQL count query. 
      Organization.reset_counters p.id, :users
    end

  end

	


end