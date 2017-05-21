# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
nameWithMeasure = (t)->
    "#{t.ru_name}#{if t.ru_measure isnt '' then ", #{t.ru_measure}" else ''}"
@PropertyTypeForm = React.createClass
    getInitialState: ->
        name: ""
        short_name: ""
        measure: ""
        value_type: "integer"
        
        tag: ""
    cngHandle: (e)->
        n = e.target.name
        @setState "#{n}": e.target.value
    submitHandle: (e)->
        e.preventDefault()
        $.post(
                "/property_types"
                {property_type: @state}
                (d)=>
                    if d.status is "ok" 
                        @props.handleNewRec(d.property_type)
                        @setState @getInitialState
                    else alert("Не удалось добавить новы параметр")
                "json"
               )
    render: ->
        React.DOM.div
            className: "row"
            React.DOM.div
                className: "small-12 columns"
                React.DOM.div
                    id: "property_type_form"
                    React.DOM.div
                        className: "row"
                        React.DOM.div
                            className: "small-6 medium-3 columns"
                            React.DOM.input
                                type: "text"
                                name: "name"
                                placeholder: "Полное название"
                                value: @state.name
                                onChange: @cngHandle
                        React.DOM.div
                            className: "small-6 medium-3 columns"
                            React.DOM.input
                                type: "text"
                                name: "short_name"
                                placeholder: "Сокр. название"
                                value: @state.short_name
                                onChange: @cngHandle
                        React.DOM.div
                            className: "small-6 medium-3 columns"
                            React.DOM.input
                                type: "text"
                                name: "measure"
                                placeholder: "Мера измерения"
                                value: @state.measure
                                onChange: @cngHandle
                        React.DOM.div
                            className: "small-6 medium-3 columns"
                            React.DOM.input
                                type: "text"
                                name: "tag"
                                placeholder: "Служебный тэг"
                                value: @state.tag
                                onChange: @cngHandle
                    React.DOM.div
                        className: "row"
                        React.DOM.div
                            className: "small-6 medium-3 columns"
                            React.DOM.select
                                name: "value_type"
                                value: @state.value_type
                                onChange: @cngHandle
                                for vt in @props.value_types
                                    React.DOM.option
                                        key: vt[0]
                                        value: vt[0]
                                        vt[1]
                        React.DOM.div
                            className: "small-6 medium-3 end columns"
                            React.DOM.button
                                type: "submit"
                                className: "button success"
                                onClick: @submitHandle
                                "Добавить"
PropTypesRow = React.createClass
    editPT: (e)->
        e.preventDefault()
    delPT: (e)->
        e.preventDefault()
        $.ajax
               method: 'DELETE'
               url: "/property_types/#{ @props.pt.id }"
               dataType: 'JSON'
               success: (d)=> if d.status is "ok" then @props.delHandle @props.pt else alert "Не удалось удалить тип свойства"
               error: ()-> alert "Не удалось удалить тип свойства. Проблема с сервером"
    setEdit: (e)->
        e.preventDefault()
        @props.toggleHandle(if @props.is_edit then null else @props.pt.id)
    update: (e)->
        e.preventDefault()
        data = 
            name: @refs.name.value
            short_name: @refs.short_name.value
            measure: @refs.measure.value
        $.ajax
            method: "PUT"
            url: "/property_types/#{@props.pt.id}"
            dataType: "JSON"
            data:
                property_type: data
            success: (d)=>
                if d.status is "ok"
                    @props.updHandle(@props.pt, d.property_type)
                else
                    alert("Не удалось обновить тип свойства")
            error: (e)->
                alert("Ошибка на сервере.")
                 
    render: ->
        if @props.is_edit
            React.DOM.tr null,
                React.DOM.td null, 
                    React.DOM.input
                        type: "text"
                        defaultValue: MultLocStr(@props.pt.ru_name, @props.pt.com_name)
                        ref: "name"
                React.DOM.td null,
                     React.DOM.input
                         type: "text"
                         defaultValue: MultLocStr(@props.pt.ru_short_name, @props.pt.com_short_name)
                         ref: "short_name"
                React.DOM.td null,
                     React.DOM.input
                         type: "text"
                         defaultValue: MultLocStr(@props.pt.ru_measure, @props.pt.com_measure)
                         ref: "measure"
                React.DOM.td null,
                     React.DOM.input
                         type: "text"
                         placeholder: "Служебный тэг"
                         defaultValue: @props.pt.tag 
                         ref: "tag"
                React.DOM.td null, "#{@props.pt.value_type}"
                React.DOM.td null, 
                    React.DOM.a
                        onClick: @update
                        React.createElement FIcon, fig: "save"
                React.DOM.td null, 
                    React.DOM.a
                        onClick: @setEdit
                        React.createElement FIcon, fig: "x"
        else
            React.DOM.tr null,
                React.DOM.td null, MultLocStr(@props.pt.ru_name, @props.pt.com_name)
                React.DOM.td null, MultLocStr(@props.pt.ru_short_name, @props.pt.com_short_name)
                React.DOM.td null, MultLocStr(@props.pt.ru_measure, @props.pt.com_measure)
                React.DOM.td null, "#{@props.pt.tag}"
                React.DOM.td null, "#{@props.pt.value_type}"
                React.DOM.td null, 
                    React.DOM.a
                        onClick: @setEdit
                        React.createElement FIcon, fig: "pencil"
                React.DOM.td null, 
                    React.DOM.a
                        onClick: @delPT
                        React.createElement FIcon, fig: "trash"

                    
@PropertyTypesControl = React.createClass
    getInitialState: ->
        types: @props.property_types
        value_types: @props.value_types
        curEdit: null
    getDefaultProps: ->
        types: []
        value_types: []
    setEdit: (id)->
        @setState curEdit: id
    updPT: (r, d)->
        types = @state.types
        types = UpdArrItem(types, r, d)
        @setState types: types, curEdit: null
    addPT: (r)->
        types = @state.types.slice()
        types.push r
        @setState types: types
    delPT: (r)->
        types = @state.types.slice()
        idx = types.indexOf r
        types.splice idx, 1
        @setState types: types
    render: ->
        React.DOM.div null,
            React.createElement PropertyTypeForm, handleNewRec: @addPT, value_types: @state.value_types
            React.DOM.table null,
                React.DOM.thead null,
                    React.DOM.tr null,
                        React.DOM.th null, "название {en}"
                        React.DOM.th null, "кратко {en}"
                        React.DOM.th null, "мера {en}"
                        React.DOM.th null, "тэг"
                        React.DOM.th null, "тип"
                        React.DOM.th null, ""
                        React.DOM.th null, ""
                React.DOM.tbody null,
                    for pt in @state.types
                        React.createElement PropTypesRow, key: "property_type_#{pt.id}", pt: pt, delHandle: @delPT, is_edit: (pt.id is @state.curEdit), toggleHandle: @setEdit, updHandle: @updPT


PropertyTypeSelListItem = React.createClass
    rmItem: (e)->
        e.preventDefault()
        @props.handleRemove(@props.pt)
    cngReqFlag: (e)->
        e.preventDefault()
        @props.pt.is_required = !@props.pt.is_required
        @props.handleUpd(@props.pt)
    clone: ->
        {
            id: @props.pt.id
            is_required: @props.pt.is_required
            ru_name: @props.pt.ru_name
            ru_measure: @props.pt.ru_measure
            order_number: @props.pt.order_number
        }
    mvUp: (e)->
        e.preventDefault()
        pt = @clone()
        pt.order_number = pt.order_number-1
        @props.handleUpd(pt)
    mvDwn: (e)->
        e.preventDefault()
        pt = @clone()
        pt.order_number = pt.order_number+1
        @props.handleUpd(pt)
    render: ->
        React.DOM.tr null,
            React.DOM.td null, 
                React.DOM.input 
                    type: "hidden"
                    name: "#{@props.form_name}[product_types_property_types_attributes][#{@props.pt.order_number}][property_type_id]"
                    value: @props.pt.id
                React.DOM.input 
                    type: "hidden"
                    name: "#{@props.form_name}[product_types_property_types_attributes][#{@props.pt.order_number}][is_required]"
                    value: @props.pt.is_required
                React.DOM.input 
                    type: "hidden"
                    name: "#{@props.form_name}[product_types_property_types_attributes][#{@props.pt.order_number}][order_number]"
                    value: @props.pt.order_number  
                nameWithMeasure(@props.pt)
            React.DOM.td null, 
                React.DOM.a 
                    onClick: @cngReqFlag
                    React.createElement IconWithText, txt: (if @props.pt.is_required then "да" else "нет"), fig: if @props.pt.is_required then "check" else "x"
            React.DOM.td null, 
                React.DOM.a 
                    onClick: @mvDwn
                    React.createElement FIcon, fig: "arrow-down"
                React.DOM.a 
                    onClick: @mvUp
                    React.createElement FIcon, fig: "arrow-up"
            React.DOM.td
                className: "text-right", 
                React.DOM.a
                    className: "button small secondary"
                    onClick: @rmItem
                    React.createElement FIcon, fig: "minus"
                    
@PropertyTypeSelectList = React.createClass
    getInitialState: ->
        all: @props.all
        selected: if @props.selected is undefined then [] else @props.selected
        form_name: @props.form_name
    getDefaultState: ->
        all: []
        selected: []
    valForInput: (s)->
        v = s.map((i)-> i.id).join(',') 
        console.log v
        v
    addItem: (e)->
        e.preventDefault()
        idx = IndexOfById(@state.all, parseInt @refs.selected_property.value)
        if idx is -1 then return
        s = @state.selected.slice()
        s.push {id: @state.all[idx].id, is_required: false, order_number: s.length+1, ru_name: @state.all[idx].ru_name, ru_measure: @state.all[idx].ru_measure}
        @setState selected: s
        #console.log @refs.selected_property.value
        #@props.handleChange(@valForInput(s))
    rmvItem: (i)->
        s = @state.selected.slice()
        idx = s.indexOf i
        s.splice idx, 1
        s.map (v, i)-> v.order_number = i+1
        @setState selected: s
        #@props.handleChange(@valForInput(s))
    changeNumber: (item, idx)->
        console.log idx
        selected = @state.selected.slice()
        nextNumber = (selected[idx].order_number + (item.order_number - selected[idx].order_number)) - 1
        if (nextNumber is selected.length || nextNumber is -1)
            nextNumber = if nextNumber is -1 then selected.length-1 else 0
            newArr = []
            item.order_number = nextNumber+1
            if nextNumber is 0 
                newArr[0] = item
                for i in [0..selected.length-2]
                    selected[i].order_number = newArr.length + 1
                    newArr[newArr.length] = selected[i]
            else
                for i in [1..selected.length-1]
                    selected[i].order_number = newArr.length + 1
                    newArr[newArr.length] = selected[i]
                newArr[newArr.length] = item
            selected = newArr
        else
            cur = selected[idx]
            next = selected[nextNumber]
            selected[next.order_number-1] = cur
            selected[cur.order_number-1] = next
            for i in [0..selected.length-1]
                selected[i].order_number = i+1
        selected
    updItem: (i)->
        s = @state.selected.slice()
        idx = IndexOfById(s, i.id)
        if idx is -1 then return
        console.log "#{i.order_number} #{s[idx].order_number}"
        if s[idx].order_number isnt i.order_number
            s = @changeNumber(i, idx)
        else
            s[idx] = i
        @setState selected: s
    render: ->
        React.DOM.div 
            className: "tb-pad-s",
            React.DOM.div
                className: "row"
                React.DOM.div
                    className: 'small-12 columns'
                    React.DOM.h5 null, "Технические характеристики"
            React.DOM.div
                className: "row"
                React.DOM.div 
                    className: "small-12 medium-8 end columns"
                    React.DOM.table null,
                        React.DOM.thead null,
                            React.DOM.tr null,
                                React.DOM.th null,
                                    "Название свойства"
                                React.DOM.th null,
                                    "Обязательно"
                                React.DOM.th
                                     colSpan: 2
                                     null
                        React.DOM.tbody null,
                            React.DOM.tr null,
                                React.DOM.td
                                    colSpan: 3
                                    React.DOM.select
                                        onChange: @onCng
                                        ref: "selected_property"
                                        for t in @state.all
                                            if IndexOfById(@state.selected, t.id) is -1
                                                React.DOM.option
                                                    key: t.id
                                                    value: t.id
                                                    nameWithMeasure(t)
                                React.DOM.td
                                    style: {verticalAlign: "middle"}
                                    className: 'text-right'
                                    React.DOM.a
                                        className: "button small"
                                        style: {top: "15px"}
                                        onClick: @addItem
                                        React.createElement FIcon, fig: "plus"
                        React.DOM.tbody null,
                            if @state.selected.length is 0 
                                React.DOM.tr null, 
                                    React.DOM.td
                                        colSpan: 4
                                        React.DOM.input
                                            type: "hidden"
                                            name: "#{@state.form_name}[product_types_property_types_attributes][]"
                                        React.DOM.p null, "Список характеристик пуст"
                            else
                                for s in @state.selected
                                    React.createElement PropertyTypeSelListItem, key: s.id, pt: s, handleRemove: @rmvItem, form_name: @state.form_name, handleUpd: @updItem

                    
                                
    