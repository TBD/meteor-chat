console.log 'server start'
Messages = new Meteor.Collection("messages")

# cleanup
Messages.remove({})

# start items
Messages.insert
	text: 'hello world from @tbd cc @tw @fb #test #personal'
	avatar: ''
	when: new Date()

Messages.insert
	text: 'another message'
	avatar: ''
	when: new Date()

# publish all
Meteor.publish 'messages', ->
	Messages.find {}

Meteor.publish null, ->
	Meteor.users.find {},
	    fields:
	        username: 1
	        profile: 1

Meteor.methods
	'addMessage': (message) ->
		if message
			Messages.insert 
				text: message
				user: Meteor.user()
				when: new Date()
