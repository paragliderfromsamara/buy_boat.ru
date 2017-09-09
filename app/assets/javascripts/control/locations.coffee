# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

prompt = (n)-> "<option value = \"0\">Выберите #{if n isnt "cities" then "регион" else "населенный пункт"}</option>"

resetList = (l)-> l.html(prompt(l[0].id)) 

changeLocField = (el)->
    if $(el).val() is "0"
        if el.id is "countries" then resetList($("#regions"))
        resetList($("#cities"))
        return
    updEl = if el.id is "countries" then "regions" else "cities"
    if updEl is "regions" then $("#cities").attr("disabled", "") else $("#cities").removeAttr("disabled")
    l = "/locations/#{updEl}/#{$(el).val()}"
    $.getJSON(l, {}, (data)->
                             resetList($("#cities"))
                             v = "<option value = \"0\">Выберите #{if el.id is "countries" then "регион" else "населенный пункт"}</option>"
                             for d in data
                                 v += "<option value = \"#{d.id}\">#{d.name}</option>" 
                             $("##{updEl}").html v
             )

document.addEventListener "turbolinks:load", ()->
    f = document.getElementById("location-field")
    if f isnt null
        f = $(f)
        f.find("#countries, #regions").change ()-> changeLocField(this)
        f.find("#countries").change()
         