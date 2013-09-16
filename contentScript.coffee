class ContentScript
	constructor: () ->

class WhenReady
	constructor: (@callback)->		
		next = @ready
		self = @
		document.addEventListener('DOMContentLoaded', (domEvent) ->
			#console.log('DomReady')
			document.body.onload = (bodyEvent) ->
				#console.log('BodyReady')
				next.apply(self, [domEvent, bodyEvent])
		, false)
	ready: () ->
		@callback.apply(@, [])

@.listener = new WhenReady( () ->
	console.log('Im ready')
)

@.contentScript = new ContentScript()