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

	$('.voting a').bind 'ajax:success', (e, data, status, xhr) ->
		votable = $.parseJSON(xhr.responseText)
		$(this).closest('.voting.col-sm-2').find('span.h2').html(votable.rating)
		if $(this).hasClass('thumbs-up')
			$(this).find('i.fa-thumbs-o-up').removeClass('text-muted').addClass('text-success')
			$(this).closest('.voting.col-sm-2').find('i.fa-thumbs-o-down').removeClass('text-danger').addClass('text-muted')
		else
			$(this).find('i.fa-thumbs-o-down').removeClass('text-muted').addClass('text-danger')
			$(this).closest('.voting.col-sm-2').find('i.fa-thumbs-o-up').removeClass('text-success').addClass('text-muted')
			

$(document).ready setup
$(document).on 'page:load', setup

$(document).on 'nested:fieldAdded', (e) ->
	field = e.field
	fileField = field.find('input[type=file]')
	fileField.click().change (e) ->
		fileName = $(this).val().split('\\').pop()
		$('.form-attachments').append(fileName + ' ')