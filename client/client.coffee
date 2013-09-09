Messages = new Meteor.Collection("messages")
Meteor.subscribe 'messages'

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


Template.messages.messages = ->
	Messages.find()

Template.message.helpers
	avatar: ->
		user = @.user
		if user? and user.services?
			user.services.google.picture
		else
			'/img/anon.png'
	created: ->
		time = moment @.when;
		time.format('D.MMM H:mm');
	text: ->
		text = @.text
		text = text.replace(/#([a-z\d_]+)/ig, '<a href="/topic/$1">#$1</a>')
		text.replace(/@([a-z\d_]+)/ig, '<a href="/user/$1">@$1</a>')
