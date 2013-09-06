Meteor.subscribe 'messages'

# --- messages

Template.messages.messages = ->
	Messages.find().fetch()

Template.entry.events = 
	'keydown': (event, template) -> 
		switch event.keyCode
			# enter
			when 13 
				entry = template.find('#entry')
				Meteor.call('addMessage', entry.value)
				entry.value = ''
				entry.focus()

Template.entry.rendered = ->
	$('#entry').atwho
		at: '@'
		data: ['TBD', 'Bot', 'Test']

# --- users

Template.users.users = ->
	Meteor.users.find()


