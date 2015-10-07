WebMock.stub_request(:post, "https://heapanalytics.com/api/identify").
         to_return(:status => 200, :body => "", :headers => {})