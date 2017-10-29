# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

isRuLocale = (document.location.href).indexOf(".ru") > 0
viewerElementId = "photo-viewer"
nextArrId = "next_ph"
prevArrId = "prev_ph"
counterId = "ph_counter"
middleImgEscId = "close_reveral"
#атрибуты
collAttrName = "data-collection" #атрибут названия коллекции фотографий
titleAttrName = "data-rc-box-title" #атрибут примечания к фото
curImgAttrName = "is-cur-img" #атрибут отмечающий фотографию которая открыта сейчас
imgIdxAttrName = "data-image-idx" #индекс фотографии
imgListAttrName = "data-image-versions" #атрибут, содержащий ссылку на отображаемую в слайдере фотографию
viewer = null 
enableViewerKeys = true #когда происходит переход на другое фото, флаг ставится в false, как только произошел переход флаг возвращается в состояние true
curCollectionName = undefined
urlsCollection = new Object() 
curIdx = 0

updViewerCounterText = (idx, count)->
    if count > 1
        h = if isRuLocale then {"photo": "фото", "fr": "из"} else {"photo": "photo", "fr": "of"}
        txt = "#{h.photo} <span class = \"rc-bold\">#{idx}</span> #{h.fr} <span class = \"rc-bold\">#{count}</span>"
    else 
        txt = ""
    viewer.find("##{counterId}").html txt
    return

togglleArrow = (arr_id, act_is_show)->
    if act_is_show then viewer.find("##{arr_id}").show() else viewer.find("##{arr_id}").hide()

showFunc = (el)->
    $(el).attr("#{curImgAttrName}", true)
    viewer.find("##{titleAttrName}").text($(el).attr(titleAttrName))
    enableViewerKeys = true

buildPhoto = (idx)->
    "<img #{imgIdxAttrName} = \"#{idx}\" #{titleAttrName} = \"#{urlsCollection[curCollectionName][idx].title}\" data-interchange = \"#{urlsCollection[curCollectionName][idx].imgs}\">"
    #"<img #{titleAttrName} = \"#{urlsCollection[colName][idx]["title"]}\" #{collAttrName} = \"#{colName}\" #{imgIdxAttrName} = \"#{idx}\" data-interchange = \"#{urlsCollection[colName][idx]["title"]}\">"

checkInViewer = (idx)->
    cr = "img[data-interchange='#{urlsCollection[curCollectionName][idx].imgs}']"
    img = viewer.find(cr)
    if img.length is 0 
        ph = buildPhoto(idx)
        viewer.find("#ph-container").append(ph)
        ph = viewer.find(cr)
        ph.hide()
        ph.foundation()
    

showPhotoByIdx = (idx)->
    collection = urlsCollection[curCollectionName]
    if collection is undefined
        console.error "Коллекции изображений с названием #{curCollectionName} не существует"
    else
        l = collection.length
        if idx > -1 && idx < l
            curImagesList = collection[idx].imgs
            checkInViewer(idx)
            #img.foundation()
            #before        
            curColTrueSelector = "img[data-interchange='#{curImagesList}']" 
            curColFalseSelector = "img[data-interchange!='#{curImagesList}']"
            togglleArrow(prevArrId, (idx>0))
            togglleArrow(nextArrId, (idx<l-1))
            updViewerCounterText(idx+1, l)
            viewer.find(curColFalseSelector).hide(0, ()->
                                                    $(this).attr("#{curImgAttrName}", false)
                                                    viewer.find("##{titleAttrName}").text("")
                                                    )
            viewer.find(curColTrueSelector).fadeIn(300, ()-> showFunc(this))
            #console.log "#{idx} -- #{l}"
    
getCurIdx = ()->
    parseInt(viewer.find("img[#{curImgAttrName}=true]").attr("#{imgIdxAttrName}"))

changePhoto = (id)->
    idx = getCurIdx()
    if id is prevArrId
        idx--
    else
        idx++
    showPhotoByIdx(idx)

initBoxPhotos = (phs)->
    clc = idx = 0
    box_phs = ""
    colName = ""
    urlsCollection = {}
    for p in phs
        #urlsCollection[urlsCollection.length] = $(p).attr("#{imgListAttrName}")
        if !p.hasAttribute("#{collAttrName}")
            clc++
            idx = 0
            colName = "collection_#{clc}"
            urlsCollection[colName] = []
        else
            colName = $(p).attr("#{collAttrName}")
            if urlsCollection[colName] is undefined
                idx = 0
                urlsCollection[colName] = []
            else
                idx = urlsCollection[colName].length
        $(p).parents("a").attr("data-open", viewerElementId)
        $(p).attr("#{collAttrName}", colName)
        $(p).attr("#{imgIdxAttrName}", "#{idx}")
        $(p).parents("a").click ()-> 
            curCollectionName = $(this).find("img").attr("#{collAttrName}")
            showPhotoByIdx(parseInt($(this).find("img").attr("#{imgIdxAttrName}")))    
        urlsCollection[colName][idx] = {
                                            imgs: $(p).attr("#{imgListAttrName}")
                                            title: if p.hasAttribute(titleAttrName) then " "+$(p).attr(titleAttrName) else ""
                                        }
        #box_phs += "<img #{titleAttrName} = \"#{if p.hasAttribute(titleAttrName) then $(p).attr(titleAttrName) else ""}\" #{collAttrName} = \"#{colName}\" #{imgIdxAttrName} = \"#{idx}\" data-interchange = \"#{if p.hasAttribute(imgListAttrName) then $(p).attr(imgListAttrName) else "[#{$(p).attr("src")}, small]"}\">"
    #console.log urlsCollection

@InitViewer = ()-> 
    console.log "InitViewer"
    bPhotos = document.getElementsByClassName("kra-ph-box")
    if bPhotos.length > 0
        initBoxPhotos(bPhotos)
        if document.getElementById(viewerElementId) is null 
            $("body").append("<div class=\"reveal\" id=\"#{viewerElementId}\" data-reveal data-v-offset = \"10%\"><div id = \"viewer-info\"><span id = \"#{counterId}\"></span><span id = \"#{titleAttrName}\"></span></div> <div id = \"ph-container\"><div id = \"#{prevArrId}\" class = \"arrows\"><span>&#12296;</span></div><div data-close id = \"#{middleImgEscId}\"></div><div id = \"#{nextArrId}\" class = \"arrows\"><span>&#12297;</span></div></div><button style = \"position: absolute;\" class=\"close-button\" data-close type=\"button\"><span aria-hidden=\"true\">&times;</span></button></div>")
            $("##{viewerElementId}").foundation()    
        viewer = $("##{viewerElementId}")
        viewer.find(".arrows").click ()-> changePhoto(this.id) 
        
        viewer.keydown (event)->
            if not enableViewerKeys then return
            enableViewerKeys = false 
            curIdx = getCurIdx()
            if event.keyCode is 37
                curIdx--
                showPhotoByIdx(curIdx)
                #return
            if event.keyCode is 39
                curIdx++
                showPhotoByIdx(curIdx)
                #return
            #console.log "#{curIdx}"
                                           
        #elem = new Foundation.Reveal($("#photo-viewer"), {});
