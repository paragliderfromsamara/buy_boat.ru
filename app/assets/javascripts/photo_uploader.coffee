# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

upldPhoto = (ph, id)->
    "
    <div class = \"column column-block tb-pad-s\">
        <a href = \"/boat_types/#{id}/photos/#{ph.id}\" data-remote = true data-method = \"delete\"><i class = 'fi-x'></i></a>
            <br/>
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
                    cnt.append(upldPhoto(ph, response.id))
            setTimeout ()->
                $(".dz-preview").each ()->
                    if $(this).hasClass('dz-complete') 
                        $(this).remove()
                        Dropzone.reset()
                50           
            })
                                   
document.addEventListener "turbolinks:load", initUploder