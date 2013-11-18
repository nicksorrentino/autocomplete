do ($ = jQuery) ->
    $.fn.autocomplete = (opts) ->
        opts = opts or {}
        ajax_url = opts.url || "/autocomplete"
        $input = this
        $searchForm = opts.form || $input.parent("form")
        $selectedItem = null
        autoAjax = null
        currentQuery = null
        keyMap =
            27 : 'esc'
            13 : 'enter'
            38 : 'up'
            40 : 'down'

        if ( ! opts.div )
            $autocomplete = $("<div/>")
            $input.after($autocomplete)
        else
            $autocomplete = $(opts.div)

        inputBlur = ->
            setTimeout ->
                hideAutocomplete()
            , 500
        clickAutocomplete = (e) ->
            #console.log("cliky")
            $this = $(this)
            $input.val( $this.text() )
            $searchForm.trigger("submit")
            return

        hideAutocomplete = ->
            $selectedItem = null
            $autocomplete.html('').hide()

        nonLetterEvent = (k) ->
            #console.log($selectedItem)
            switch k
                when 'esc'
                    hideAutocomplete()
                when 'enter'
                    hideAutocomplete()
                when 'up'
                    if ( $selectedItem )
                        $prev = $selectedItem.prev()
                        if ( $prev.length )
                            $selectedItem.removeClass("active")
                            $selectedItem = $prev
                            $selectedItem.addClass("active")
                            $input.val($selectedItem.text())
                        else
                            $selectedItem.removeClass("active")
                            $selectedItem = null

                when 'down'
                    if ( $selectedItem )
                        $next = $selectedItem.next()
                        if ( $next.length )
                            #console.log "highlighting next"
                            #console.log $next
                            $selectedItem.removeClass("active")
                            $selectedItem = $next
                            $selectedItem.addClass("active")
                            $input.val($selectedItem.text())
                    else
                        $item = $autocomplete.find("a").eq(0)
                        if ( $item.length )
                            $selectedItem = $item
                            $selectedItem.addClass("active")
                            $input.val($selectedItem.text())



        keypress = (e)->
            query = $input.val()
            key = e.which or e.keyCode
            $autocomplete.show()

            #console.log("keypress")

            if char = keyMap[key]
                e.preventDefault()
                e.stopImmediatePropagation()
                e.stopPropagation()
                return nonLetterEvent(char)
            #if another call already dont abort it
            autoAjax.abort?() if autoAjax
            #console.log("keypress")

            return if currentQuery == query
            currentQuery = query

            autoAjax = $.ajax
                url: ajax_url
                data: { q: query }
                dataType: 'json'
                success: autocompleteResponse

            return
            

        autocompleteResponse = (d) ->
            d = $.parseJSON(d) if ( typeof d == "string" )
            query = d[0]
            results = d[1]
            $div = $("<div/>")
            return hideAutocomplete() if not results?.length
            for r, index in results
                sug = r
                sugBold = sug.replace(query.toLowerCase(), (a) -> "<span>#{a}</span>")
                $li = $ "<a/>",
                    html: sugBold
                $div.append($li)
                break if index > 7

            $autocomplete.html($div)

        $input.on({"keyup": keypress, "blur": inputBlur})
        $autocomplete.on("click", "a", clickAutocomplete)
        $searchForm.on("submit", hideAutocomplete)
    return



