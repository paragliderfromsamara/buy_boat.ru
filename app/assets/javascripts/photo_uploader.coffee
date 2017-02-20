# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

upldPhoto = (ph)->
    "
    <div class = \"column column-block tb-pad-s\">
        <img data-photo-id = #{ph.id} src = \"#{ph.thumb}\" class = \"thumbnail\" />
    </div>
    "

initUploder = ->
    cnt = $("#uploaded-photos-container")
    $("form.dropzone").dropzone({
        method: "PUT"
        paramName: "boat_type[photos_attributes][link]"
        success: (file, response)->
            for ph in response.photos_hash_view
                if cnt.find("[data-photo-id=#{ph.id}]").length is 0
                    cnt.append(upldPhoto(ph))
            setTimeout ()->
                $(".dz-preview").each ()->
                    if $(this).hasClass('dz-complete') 
                        $(this).remove()
                        Dropzone.reset()
                50           
            })
                                   
document.addEventListener "turbolinks:load", initUploder