photoControlItem = React.createClass
    getInitialState: ->
        is_main: @props.photo.is_main
        is_slider: @props.photo.is_slider
    isChanged: ->
        (@props.photo.is_main isnt @state.is_main) or (@props.photo.is_slider isnt @state.is_slider)
    rmvHandle: (e)->
        e.preventDefault()
        toRmv = confirm("Вы действительно хотите удалить фотографию?")
        if toRmv 
            $.ajax 
                url: "/photos/#{@props.photo.id}/#{@props.entity}/#{@props.entityId}"
                type: 'DELETE'
                dataType: 'json'
                success: (data)=>
                    @props.removePhoto(@props.photo)
                error: (jqXHR, textStatus, errorThrown)->
                    XHRErrMsg(jqXHR)
    changeInputHandle: (e)->
        name = e.target.name
        value = e.target.value
        @setState "#{ name }": value
    openEditForm: (e)->
        e.preventDefault()
        $("#edit-ph-#{@props.photo.id}").foundation('open')
    componentDidMount: ->
        $("#edit-ph-#{@props.photo.id}").foundation()
        $("#edit-ph-#{@props.photo.id}").on('closed.zf.reveal', ()=> @updEntityPhoto())
    updEntityPhoto: ->
        if @isChanged()
            $.ajax 
                url: "/photos/#{@props.photo.id}/#{@props.entity}/#{@props.entityId}"
                type: 'PUT'
                dataType: 'json'
                data: {entity_photo: @state}
                success: (data)=>
                    @props.updPhotosList(data)
                error: (jqXHR, textStatus, errorThrown)->
                    XHRErrMsg(jqXHR)
    boatTypeInputs: ->
        React.DOM.div
            className: 'row tb-pad-s'
            React.DOM.div
                className: 'small-12 medium-6 columns'
                React.createElement YesNowDropdownList, key: 'is_main', inputName: 'is_main', value: @state.is_main, label: 'Использовать как главное', changeEvent: @changeInputHandle
            React.DOM.div
                className: 'small-12 medium-6 columns'
                React.createElement YesNowDropdownList, key: 'is_slider', inputName: 'is_slider', value: @state.is_slider, label: 'Показывать в слайдере', changeEvent: @changeInputHandle
    defaultInputs: ->
        React.DOM.div
            className: 'row tb-pad-s'
            React.DOM.div
                className: 'small-12 medium-6 end columns'
                React.createElement YesNowDropdownList, key: 'is_main', inputName: 'is_main', value: @state.is_main, label: 'Использовать как главное', changeEvent: @changeInputHandle
    editForm: ->
        React.DOM.div
            className: 'reveal'
            'data-reveal': true
            id: "edit-ph-#{@props.photo.id}"
            React.DOM.img
                src: @props.photo.medium
            if @props.entity is 'boat_type' then @boatTypeInputs() else @defaultInputs()

    render: ->
        React.DOM.div
            className: 'column column-block tb-pad-s'
            @editForm()
            React.DOM.div
                style: {width: '100%', height: '100%', position: 'relative'}
                React.DOM.div
                    style: {width: '100%', position: 'absolute', top: '10px', left: '10px'}
                    if @props.photo.is_main then React.createElement FIconBadge, fig: 'star', color: 'alert', title: 'Используется как главное'
                    if @props.photo.is_slider then React.createElement FIconBadge, fig: 'layout', color: 'success', title: 'Используется в слайдере' 
                React.DOM.div
                    style: {width: '100%', position: 'absolute', bottom: '0px'}
                    React.DOM.div
                        className: 'button-group'
                        React.DOM.a 
                            onClick: @rmvHandle 
                            className: 'button alert tiny'
                            React.createElement IconWithText, fig: 'trash', txt: 'Удалить'
                        React.DOM.a
                            onClick: @openEditForm
                            className: 'button tiny'
                            React.createElement IconWithText, txt: 'Изменить', fig: 'pencil'
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
                React.DOM.p null, "Нет ни одной фотографии"
    removePhotoFromList: (photo)->
        phs = []
        for ph in @state.photos
            if ph.id isnt photo.id then phs.push(ph)
        @setState photos: phs
    photosList: ->
        React.DOM.div
            className: 'row small-up-1 medium-up-3 large-up-4 '
            for p in @state.photos
                React.createElement photoControlItem, key: "photo-#{p.id}", photo: p, removePhoto: @removePhotoFromList, entity: @state.entity, entityId: @state.entityId, updPhotosList: @updPhotosList
            
    updPhotosList: (photos)->
        @setState photos: photos
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

            