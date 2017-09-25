photoControlItem = React.createClass
    getInitialState: ->
        is_main: @props.photo.is_main
        is_slider: @props.photo.is_slider
    rmvHandle: (e)->
        e.preventDefault()
        toRmv = confirm("Вы действительно хотите удалить фотографию?")
        if toRmv 
            $.ajax 
                url: "/entity_photos/#{@props.photo.entity_photo_id}"
                type: 'DELETE'
                dataType: 'json'
                success: (data)=>
                    @props.updPhotosList(data)
                error: (jqXHR, textStatus, errorThrown)->
                    XHRErrMsg(jqXHR)
    updEntityPhoto: (attrs)->
        #if @isChanged()
        $.ajax 
            url: "/entity_photos/#{@props.photo.entity_photo_id}"
            type: 'PUT'
            dataType: 'json'
            data: {entity_photo: attrs}
            success: (data)=>
                console.log data
                @props.updPhotosList(data)
            error: (jqXHR, textStatus, errorThrown)->
                XHRErrMsg(jqXHR)
    switchIsMainFlag: (e)->
        e.preventDefault()
        attrs = {is_slider: @state.is_slider, is_main: !@state.is_main}
        @updEntityPhoto(attrs)
    switchIsSliderFlag: (e)->
        e.preventDefault()
        attrs = {is_slider: !@state.is_slider, is_main: @state.is_main}
        @updEntityPhoto(attrs)
        
    mainFlagBadge: ->
        React.DOM.a
            onClick: @switchIsMainFlag
            React.createElement FIconBadge, fig: 'star', color: (if @state.is_main then 'alert' else 'secondary'), title: (if @state.is_main then 'Не использовать как главное' else 'Использовать как главное')
    sliderFlagBadge: ->
        React.DOM.a
            onClick: @switchIsSliderFlag     
            React.createElement FIconBadge, fig: 'layout', color: (if @state.is_slider then 'success' else 'secondary'), title: (if @state.is_slider then 'Не использовать в слайдере' else 'Использовать в слайдере') 
    render: ->
        React.DOM.div
            className: 'column column-block tb-pad-s'
            React.DOM.div
                style: {width: '100%', height: '100%', position: 'relative'}
                React.DOM.div
                    style: {width: '100%', position: 'absolute', top: '10px', left: '10px'}
                    @mainFlagBadge()
                    if @props.entity is 'boat_type' then @sliderFlagBadge()
                React.DOM.div
                    style: {width: '100%', position: 'absolute', bottom: '0px'}
                    React.DOM.div
                        className: 'button-group'
                        React.DOM.a 
                            onClick: @rmvHandle 
                            className: 'button alert tiny'
                            React.createElement IconWithText, fig: 'trash', txt: 'Удалить'
                React.DOM.img
                    src: @props.photo.small
            
            
            

@PhotosControl = React.createClass
    getInitialState: ->
        entity: @props.entity
        entityId: @props.entity_id
        photos: if @props.photos is undefined then [] else @props.photos
    componentDidMount: ->
        $("div##{@props.entity}-dz").dropzone(
                            { 
                                url: "/upload_photo/#{@state.entity}/#{@state.entityId}" 
                                method: 'POST'
                                paramName: 'photo[link]'
                                sending: (file, xhr, formData)=>
                                    formData.append("authenticity_token", @props.form_token)
                                success: (file, response)=> 
                                    @updPhotosList(response)
                                    setTimeout ()->
                                        $(".dz-preview").each ()->
                                            if $(this).hasClass('dz-complete') 
                                                $(this).remove()
                                                #Dropzone.reset()
                                        if $(".dz-preview").length is 0 then $('.dropzone').removeClass 'dz-started'
                                        50
                                    
                            })
    noPhotosList: ->
        React.DOM.div 
            className: 'row'
            React.DOM.div 
                className: 'small-12 columns'
                React.DOM.p className: 'tb-pad-s', "Нет ни одной фотографии"
                
    photosList: ->
        React.DOM.div
            className: 'row small-up-1 medium-up-3 large-up-4 '
            for p in @state.photos
                React.createElement photoControlItem, key: "photo-#{p.entity_photo_id}", photo: p, entity: @state.entity, entityId: @state.entityId, updPhotosList: @updPhotosList
            
    updPhotosList: (phs)->
        @setState photos: [] 
        @setState photos: phs
    photoUploader: ->
        React.DOM.div
            className: 'row'
            React.DOM.div
                className: 'small-12 columns'
                React.DOM.div
                    id: "#{@props.entity}-dz"
                    className: 'dropzone'
                    null    
    render: ->
        React.DOM.div null,
            @photoUploader()
            if @state.photos.length > 0 then @photosList() else @noPhotosList()

            