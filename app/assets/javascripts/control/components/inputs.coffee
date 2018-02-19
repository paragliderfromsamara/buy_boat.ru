getSelectedItem = (items, v, sel)->
    if items.length is 0 then return null
    if sel is undefined || sel is null then return null
    for i in items
        if "#{i[v]}" is "#{sel}" then return i
    return null
makeDropdownItems = (items, vTitle, nTitle, nullValName, selVal)->
    value = []
    nullVal = if nullValName is undefined then {value: '', name: 'Список пуст'} else {value: '', name: nullValName}
    if vTitle is undefined then vTitle = 'id'
    if nTitle is undefined then nTitle = 'name'
    selected = getSelectedItem(items, vTitle, selVal)
    if items.length is 0
        value.push nullVal
    else
        if selected is null || selected is undefined
            if nullValName isnt undefined then value.push nullVal
            for i in items 
                value.push {value: i[vTitle], name: i[nTitle]}
        else
            value.push {value: selected[vTitle], name: selected[nTitle]}
            if nullValName isnt undefined then value.push nullVal
            for i in items 
                if selected[vTitle] isnt i[vTitle] then value.push {value: i[vTitle], name: i[nTitle]}
    return value


@YesNowDropdownList = React.createClass
    getInitialState: ->
        trueItem: {name: (if @props.trueName is undefined then 'Да' else @props.trueName), value: 1}
        falseItem: {name: (if @props.falseName is undefined then 'Нет' else @props.falseName), value: 0}
        value: @props.value
    items: ->
        if @state.value then [@state.trueItem, @state.falseItem] else [@state.falseItem, @state.trueItem]
    changeHandler: (e)->
        el = {target: {name: e.target.name, value: if e.target.value is '1' then true else false}}
        @props.changeEvent(el)
    render: ->
        React.createElement DropdownList, inputName: @props.inputName, changeEvent: @changeHandler, readyItems: @items(), label: @props.label

@DropdownList = React.createClass #{:items, :selected, :inputName, :valTitle, :nameTitle, :changeEvent, :nullValName}
    getInitialState: ->
        items: if @props.readyItems isnt undefined then @props.readyItems else makeDropdownItems(@props.items, @props.valTitle, @props.nameTitle, @props.nullValName, @props.selected)
    changeHandle: (e)->
        @props.changeEvent(e)
    labeled: ->
        React.DOM.label null, 
            @props.label
            @notLabeled()
    notLabeled: ->
        React.DOM.select
            name: @props.inputName
            onChange: @changeHandle
            for i in @state.items
                React.createElement dropdownListItem, key: "#{@props.inputName}-#{i.value}", value: i.value, name: i.name
    render: ->
        if @props.label is undefined then @notLabeled() else @labeled()




dropdownListItem = React.createClass
    render: ->
        React.DOM.option
            value: if @props.value is null or @props.value is undefined then '' else @props.value,
            @props.name

@CheckBox = React.createClass
    getInitialState: ->
        value: @props.value
    onChangeHandle: (e)->
        e.preventDefault()
        @props.changeHandle(e)
    render: ->
        React.DOM.input
            type: "checkbox"
            name: @props.inputName
            checked: @state.value
            onChange: @onChangeHandle
   

#Форма для выбора сущности из которой нужно копировать фото, или характеристики
@CopyFromForm = React.createClass
    getInitialState: ->
        boat_types: []
        type: @props.type
        copy_to: @props.boat_type_id
        formIsOpened: false
        copy_from: null
    submitFormHandle: (e)->
        e.preventDefault()
        if @state.copy_from == "" or @state.copy_from == null or @state.copy_from == undefined
            alert("Выберите модификацию")
        else
            $.post(
                    "/copy_#{@state.type}"
                    {copy_entities: {copy_from: @state.copy_from, copy_to: @state.copy_to}}
                    (data)=>
                        @props.completeHandle(data)
                    "json"
                  )
    handleClick: (e)->
        e.preventDefault()
        flag = !@state.formIsOpened
        if flag 
            $.get(
                     "/get_boat_types_list"
                     {type: @state.type}
                     (data)=>
                         f = []
                         for m in data
                             if "#{@state.copy_to}" isnt "#{m.id}" then f.push(m)
                         @setState boat_types: f, formIsOpened: flag
                     "json"
                 )
        else
            @setState formIsOpened: flag
    setCopyFrom: (e)->
        e.preventDefault()
        @setState copy_from: e.target.value   
        console.log e.target.value             
    render: ->
        React.DOM.form
            onSubmit: @submitFormHandle
            React.DOM.div
                className: "row"
                if @state.formIsOpened
                    React.DOM.div
                        className: "small-5 columns"
                        React.createElement DropdownList, items: @state.boat_types, inputName: "", valTitle: "id", nameTitle: "name", nullValName: "Выберите тип", changeEvent: @setCopyFrom
                React.DOM.div
                    className: "small-7 columns end"
                    React.DOM.div
                        className: 'button-group'
                        if @state.formIsOpened
                            React.DOM.button
                                className: 'button success'
                                type: 'submit'
                                "Скопировать"
                        React.DOM.a
                            className: "button"
                            onClick: @handleClick
                            if @state.formIsOpened then "Скрыть" else "Скопировать с другого типа"
                       