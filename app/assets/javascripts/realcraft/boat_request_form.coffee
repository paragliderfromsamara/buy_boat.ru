# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

r = ->
    $("[data-open-boat-form]").click -> #отвечает за раскрытие формы на boat_show_template
        $("#success-request").hide()
        $("#boat-form-container").find("#boat_request_boat_name").attr('value', $(this).attr('data-open-boat-form'))
        $('#boat-form-container').foundation('open')
    $("[data-form-in-price]").click -> #отвечает за раскрытие формы в pages#prices
        $("#success-request").hide()
        $('#boat-form-container').foundation('open')
    $("[data-form-in-dealers]").click ->
        $("#success-request").hide()
        $('#dealer-form-container').foundation('open')
document.addEventListener("turbolinks:load", r)