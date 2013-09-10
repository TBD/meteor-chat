Messages = new Meteor.Collection("messages")
Meteor.subscribe 'messages'


Deps.autorun () ->
	count = Messages.find().count()
	if count > 10
		Session.set 'db_skip', count - 10

Meteor.Router.add
	'/': 'home'
	'/user/:userName': (userName) ->
		Session.set 'userName', userName
		'user'
	'/topic/:topicName': (topicName) ->
		Session.set 'topicName', topicName
		'topic'

# --- template:user|topic

Template.user.userName = -> Session.get 'userName'
Template.topic.topicName = -> Session.get 'topicName'

# --- template:entry

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
	input = $('#entry')
	input.atwho
		at: '@'
		data: ['TBD', 'Bot', 'Test']
	input.focus()

# --- template:messages

Template.messages.messages = ->
	Messages.find 
		$where: ->		
			switch Meteor.Router.page()	
				when 'user' then @.text.indexOf('@' + Session.get 'userName') != -1
				when 'topic' then @.text.indexOf('#' + Session.get 'topicName') != -1
				else
					true
	,
		skip: Session.get 'db_skip' or 0	

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
