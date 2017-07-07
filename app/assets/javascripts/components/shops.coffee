
tmpCart = {} #временное хранилище выбранных товаров, {:selector, :items}

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
        React.createElement ShopProductsList, bfs: @props.bfs, updAmount: @props.updAmount 
    render: ->
        if @props.bfs.shop is null or @props.bfs.shop is undefined
            @hasNotPT()
        else
            if @props.bfs.shop.product_types.length is 0
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
    console.log ptCount    
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
                        className: "small-8 columns"
                        React.DOM.a
                            onClick: @delButClick
                            title: "Убрать"
                            React.createElement FIcon, fig: 'x'
                        "#{@props.product_type.name} #{@props.product.name} #{@props.product.count}, шт."
                    React.DOM.div
                        className: "small-4 columns"
                        SelOptAmount @props.product.amount*@props.product.count 
            
@ShopProductsList = React.createClass 
    getInitialState: ->
        shop: @props.bfs.shop
        product_types: @props.bfs.shop.product_types
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
    setProductList: (list, pt)->
        txt = ""
        tmpCart.product_type = pt
        tmpCart.products = list
        for i in list
            txt += "<div class = \"row\">
                        <div class = \"small-7 columns\">
                            <p>#{i.name}</p>
                        </div>
                        <div class = \"small-2 columns\">
                            <p>#{SelOptAmount(i.amount)}</p>
                        </div>
                        #{if tmpCart.product_type.number_on_boat is 1 then @numbOnBoatIsOne(i) else @numbOnBoatMoreOne(i)}
                    </div>"
        $("#products_list").find('#reveal_content').html "<div class = \"tb-pad-s\">#{txt}</div>"
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
            

        