# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setup = ->
	PrivatePub.subscribe '/questions', (data, channel) ->
		console.log(data)
	
	$('#search-options').click (e) ->
		e.preventDefault()
		console.log('button was pressed!')
		$('.filters').toggleClass('hidden')

$(document).ready(setup)
$(document).on('page:load', setup)