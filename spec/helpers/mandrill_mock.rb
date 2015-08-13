WebMock.stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
         to_return(:status => 200, :headers => {}, body: '[
    {
        "email": "recipient.email@example.com",
        "status": "sent",
        "reject_reason": "hard-bounce",
        "_id": "abc123abc123abc123abc123abc123"
    }
]')