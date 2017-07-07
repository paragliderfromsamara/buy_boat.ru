# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
phsContainer = null
upldPhoto = (ph, id)->
    "
    <div class = \"column column-block tb-pad-s\">
        <a href = \"/photos/#{ph.id}/#{phsContainer.attr("data-entity-name")}/#{phsContainer.attr("data-entity-id")}\" data-remote = true data-method = \"delete\"><i class = 'fi-x'></i></a>
            <br/>
        <img data-photo-id = #{ph.id} src = \"#{ph.thumb}\" class = \"thumbnail\" />
    </div>
    "
#монтируем ранее загруженные фотографии в блок
fillPhs = (phs)->
    for ph in phs
        if phsContainer.find("[data-photo-id=#{ph.id}]").length is 0
            phsContainer.append(upldPhoto(ph))
#подгружаем ранее загруженные фотографии    
getUploadedPhotos = ->
    $.get(
            "/entity_photos/#{phsContainer.attr("data-entity-name")}/#{phsContainer.attr("data-entity-id")}",
            {},
            (data)->
                fillPhs(data)
            "json"
         )

initUploder = -> 
    phsContainer = document.getElementById "uploaded-photos-container" 
    if phsContainer isnt null 
        phsContainer = $(phsContainer)
        getUploadedPhotos()
        $("form.dropzone").dropzone({
            method: "PUT"
            paramName: "#{phsContainer.attr("data-entity-name")}[photos_attributes][link]"
            success: (file, response)->
                fillPhs(response.photos_hash_view)
                setTimeout ()->
                    $(".dz-preview").each ()->
                        if $(this).hasClass('dz-complete') 
                            $(this).remove()
                            #Dropzone.reset()
                    50           
                })
                                   
document.addEventListener "turbolinks:load", initUploder