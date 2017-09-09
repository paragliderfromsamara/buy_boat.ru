
tmpCart = {} #временное хранилище выбранных товаров, {:selector, :items}

thumbnailProductPhoto = (photos)->
    if photos.length > 0 
        "<img src = \"#{photos[0].thumb_square}\">" 
    else
        "<img src = \"#{@NoPhoto("square")}\">" 

productProps = (props)->
    limit = 3
    val = ''
    for p in props
        if !limit-- then break
        if p.is_binded then val += "<p>#{PropNameWithMeasure(p, '')}     #{p.value}</p>"
    if val is '' then "<p>Список характеристик пуст.</p>" else val
ShopProductsLink = React.createClass
    handleClick: (e)->
        e.preventDefault()
        if @props.pt.products is undefined
            $.get(
                    "/shops/#{@props.shop_id}/product_types/#{@props.pt.id}",
                    {},
                    (products)=>
                        products.map (p)-> 
                            p.count = 0
                            p
                        @props.setProductList(products, @props.pt)
                 )
        else
            @props.setProductList(@props.pt.products, @props.pt)
        #console.log "/shops/#{@props.shop_id}/product_types/#{@props.pt.id}"
    render: ->   
        React.DOM.a
            className: "button"
            onClick: @handleClick
            href: "/shops/#{@props.shop_id}/product_types/#{@props.pt.id}.json"
            "Выбрать #{@props.pt.name.toLowerCase()}"
    

@ShopProductsMenu = React.createClass
    hasNotPT: -> 
        React.DOM.div null, null
    hasPT: ->
        React.createElement ShopProductsList, b: @props.b, updAmount: @props.updAmount 
    render: ->
        if @props.b.bfs.shop is null or @props.b.bfs.shop is undefined
            @hasNotPT()
        else
            if @props.b.bfs.shop.product_types.length is 0
                @hasNotPT()
            else
                @hasPT()

updCounter = (id, c)->
    $("#products_list").find("#counter-#{id}").html c
toggleButtons = (id, isAdd)->
    $("#products_list").find("a[data-product-id=#{id}]").each ()->
        if this.id is "sel"
            if isAdd then $(this).hide() else $(this).show()
        else if this.id is "unsel"
            if isAdd then $(this).show() else $(this).hide()
createProduct = (product)->
    o = new Object()
    o.name = product.name
    o.count = 0
    o
cngNumber = (id, act)->
    products = tmpCart.products.slice()
    ptCount = 0
    ptCount += p.count for p in products  
    products.map (p)->
        v = p.count
        if "#{p.id}" is id
            if act is "add" or act is "del"
                if act is "add"
                    if ptCount < tmpCart.product_type.number_on_boat then v++ else alert("Данного типа товара не должно быть выбрано более #{tmpCart.product_type.number_on_boat} шт.")
                else 
                    if v isnt 0 and act is "del" then v--
                updCounter id, v
            else if act is "sel" or "unsel"
                v = if act is "sel" then 1 else 0
                toggleButtons(p.id, act is "sel")
        else 
            if act is "sel" then v = 0
            toggleButtons(p.id, false)
        p.count = v
        p
    if act is "sel" or act is "unsel" and tmpCart.products.length is 1 then $("#products_list").foundation('close')

@ShopSelectedProduct = React.createClass
    componentDidMount: ->
        $("#sp-#{@props.product.id}").fadeIn(500)
    componentWillUnmount: ->
        $("#sp-#{@props.product.id}").fadeOut(300)
    delButClick: (e)->
        e.preventDefault()
        @props.rmvProductHandle(@props.product, @props.product_type)
    render: ->
        React.DOM.tr 
            id: "sp-#{@props.product.id}"
            style: {display: "none"},
            React.DOM.td null, 
                React.DOM.div 
                    className: "row"
                    React.DOM.div 
                        className: "small-1 columns"
                        React.DOM.img
                            src: if @props.product.photos.length > 0 then @props.product.photos[0].thumb_square else NoPhoto("square")
                    React.DOM.div 
                        className: "small-6 columns"
                        "#{@props.product_type.name} #{@props.product.name} #{@props.product.count}, шт."
                    React.DOM.div
                        className: "small-4 columns"
                        SelOptAmount @props.product.amount*@props.product.count 
                    React.DOM.div 
                        className: "small-1 columns"
                        React.DOM.a
                            onClick: @delButClick
                            title: "Убрать"
                            React.createElement FIcon, fig: 'x'
                        
@ShopProductsList = React.createClass 
    getInitialState: ->
        shop: @props.b.bfs.shop
        product_types: @props.b.bfs.shop.product_types
    calculateAmount: ->
        a = 0
        for pt in @state.product_types
            if pt.products isnt undefined
               for p in pt.products
                   a += p.count * p.amount
        a
    rmvProductFromList: (product, product_type)->
        productTypes = @state.product_types.slice()
        productTypes.map (pt)->
            if pt.id is product_type.id 
               pt.products.map (p)->
                   if p.id is product.id then p.count = 0
                   p
            pt
        @updState productTypes 
    updState: (pTypes)->
        @setState product_types: pTypes
        @props.updAmount(@calculateAmount())  
    updList: ->
        productTypes = @state.product_types.slice()
        productTypes.map (pt)->
            if pt.id is tmpCart.product_type.id then pt.products = tmpCart.products
            pt
        @updState productTypes
    numbOnBoatMoreOne: (i)->
        "
        <div class = \"small-1 columns\">
            <span id = \"counter-#{i.id}\">#{i.count}</span>
        </div>
        <div class = \"small-2 columns\">
            <a id = \"add\" data-product-id = \"#{i.id}\"><i class = \"fi-plus\"></i></a>
            <a id = \"del\" data-product-id = \"#{i.id}\"><i class = \"fi-minus\"></i></a>
        </div>
        "
    numbOnBoatIsOne: (i)->
        isSelected = i.count is 1
        unselDisp = if isSelected then "block" else "none"
        selDisp = if !isSelected then "block" else "none"
        "<div class = \"small-3 columns\">
            <a style = \"display: #{unselDisp};\" data-product-id = \"#{i.id}\" id = \"unsel\" class = \"button alert expanded\">Убрать</a>
            <a style = \"display: #{selDisp};\" data-product-id = \"#{i.id}\" id = \"sel\" class = \"button success expanded\">Выбрать</a>
         </div>"
    getCriteriaValue: (propTypeId)->
        v = null
        for prm in @props.b.parameters
            if prm.property_type_id is propTypeId# && prm.is_binded
                v = prm.value
                break
        v
    findCriterias: (productProps)->
        criterias = []
        hasCriterias = false
        for pp in productProps
            c = {
                    id: null
                    more_than: null
                    less_than: null
                    equal: null
                }
            if pp.more_than isnt null 
                hasCriterias = true
                c.id = pp.id
                c.more_than = @getCriteriaValue pp.more_than
            if pp.less_than isnt null 
                hasCriterias = true
                c.id = pp.id
                c.less_than = @getCriteriaValue pp.less_than
            if pp.equal isnt null 
                hasCriterias = true
                c.id = pp.id
                c.more_than = @getCriteriaValue pp.equal
            if c.more_than isnt null or c.less_than isnt null or c.equal isnt null then criterias.push c    
        if hasCriterias then criterias else null
    setProductList: (list, pt)->
        txt = ""
        tmpCart.product_type = pt
        tmpCart.products = list
        criterias = @findCriterias list[0].properties
        for i in list
            isAvailable = true
            if criterias isnt null
                for prodProp in i.properties
                     for c in criterias
                         if c.id is prodProp.id 
                             if c.more_than isnt null then isAvailable &= (prodProp.value >= c.more_than)
                             if c.less_than isnt null then isAvailable &= (prodProp.value <= c.less_than)
                             if c.equal isnt null then isAvailable &= (prodProp.value is c.equal)
            if isAvailable
                txt += "
                    <tr>
                        <td>
                            <div class = \"row\">
                                <div class = \"small-12 columns\">
                                    <p>#{i.name}</p>
                                </div>
                            </div>
                            <div class = \"row\">
                                <div class = \"small-2 columns\">
                                    #{thumbnailProductPhoto(i.photos)}
                                </div>
                                <div class = \"small-5 columns\">
                                    #{productProps(i.properties)}
                                </div>
                                <div class = \"small-2 columns\">
                                    <p>#{SelOptAmount(i.amount)}</p>
                                </div>
                                #{if tmpCart.product_type.number_on_boat is 1 then @numbOnBoatIsOne(i) else @numbOnBoatMoreOne(i)}
                            </div>
                        </td>
                    </tr>
                        "
        $("#products_list").find('#reveal_content').html "<div class = \"tb-pad-s\"><table>#{txt}</table></div>"
        $("#products_list").find('#reveal_header').html pt.name
        $("#products_list").find('a#add, a#del, a#sel, a#unsel').bind "click", ()-> cngNumber $(this).attr("data-product-id"), this.id
        $("#products_list").foundation('open')
    render: ->
        React.DOM.div null,
            React.DOM.div
                className: "button-group"
                for pt in @state.product_types
                    React.createElement ShopProductsLink, key: pt.id, pt: pt, shop_id: @state.shop.id, setProductList: @setProductList
            if @state.product_type isnt null
                React.createElement Reveal, 
                    id: "products_list", 
                    header: "",
                    size: 'large',
                    didMountAction: => 
                        $("#products_list").foundation()
                        $("#products_list").on("closed.zf.reveal", @updList)
            React.DOM.div null,
                React.DOM.table null,
                    React.DOM.tbody null,
                        for pt in @state.product_types
                            if pt.products isnt undefined
                                for p in pt.products
                                    if p.count > 0 then React.createElement ShopSelectedProduct, key: p.id, product: p, product_type: pt, rmvProductHandle: @rmvProductFromList
            

        