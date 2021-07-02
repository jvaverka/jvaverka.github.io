function hfun_allposts()::String
    # gather list of relative paths to blog posts
    rpaths = [joinpath("content", splitext(pn)[1]) for pn in readdir("content")]
    # define sorting algorithm based on `data` page variable
    # use creation time if no `data` page variable exists
    sorter(p) = begin
        pvd = pagevar(p, :date)
        if isnothing(pvd)
            return Date(Dates.unix2datetime(stat(p * ".md").ctime))
        end
        return pvd
    end
    # sort the list of relative paths, newest first
    sort!(rpaths, by=sorter, rev=true)
    # start writing the html unordered list
    c = IOBuffer()
    write(c, "<ul class=\"post-date\">")
    # create html list items with url, title, and publication date
    for rp in rpaths
        url = get_url(rp)
        title = pagevar(rp, :title)
        pubdate = Dates.format(Date(pagevar(rp, :date)), "u d, Y")
        write(c, "<li><a href=\"/$rp/\">$title</a><span class=\"post-date\">$pubdate</span></li>")
    end
    # finish the html
    write(c, "</ul>")
    # pass html to render page
    return String(take!(c))
end

@delay function hfun_list_tags()
    tagpages = globvar("fd_tag_pages")
    if tagpages === nothing
        return ""
    end
    @show tagpages
    tags = tagpages |> keys |> collect |> sort
    tags_count = [length(tagpages[t]) for t in tags]
    io = IOBuffer()
    for (t, c) in zip(tags, tags_count)
        write(io, """
            <nobr>
              <a href=\"/tag/$t/\" class=\"tag-link\">$(replace(t, "_" => " "))</a>
              <span class="tag-count"> ($c)</span>
            </nobr>
            """)
    end
    return String(take!(io))
end

hfun_svg_linkedin() = """<svg width="30" height="30" viewBox="0 50 512 512"><path fill="currentColor" d="M150.65 100.682c0 27.992-22.508 50.683-50.273 50.683-27.765 0-50.273-22.691-50.273-50.683C50.104 72.691 72.612 50 100.377 50c27.766 0 50.273 22.691 50.273 50.682zm-7.356 86.651H58.277V462h85.017V187.333zm135.901 0h-81.541V462h81.541V317.819c0-38.624 17.779-61.615 51.807-61.615 31.268 0 46.289 22.071 46.289 61.615V462h84.605V288.085c0-73.571-41.689-109.131-99.934-109.131s-82.768 45.369-82.768 45.369v-36.99z"/></svg>"""

hfun_svg_github() = """<svg width="30" height="30" viewBox="0 0 25 25" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"/></svg>"""

hfun_svg_gitlab() = """<svg width="34" height="30" xmlns="http://www.w3.org/2000/svg"><path d="M33.164 17.346l-1.742-5.42c-.002-.006 0-.012 0-.017L27.965 1.125A1.638 1.638 0 0026.41 0h-.01a1.626 1.626 0 00-1.541 1.135l-3.222 10.048h-9.96L8.452 1.136A1.627 1.627 0 006.908 0H6.9a1.64 1.64 0 00-1.558 1.136L1.9 11.896l-.008.014-1.746 5.436a2.248 2.248 0 00.803 2.5l15.085 11.108c.038.027.08.04.12.06.008.005.012.012.02.018l.014.005c.012.006.025.01.037.015.01.004.019.01.028.015l.012.006c.044.018.089.033.136.045.023.006.046.006.07.011.06.01.12.027.18.027.024 0 .047-.012.072-.014.072-.006.145-.016.217-.037.013-.004.028-.003.042-.007.01-.003.017-.01.026-.012.027-.01.052-.022.078-.034l.038-.015.013-.005c.018-.01.03-.026.047-.037.028-.016.06-.026.087-.044l.004-.003L32.36 19.846a2.248 2.248 0 00.804-2.5m-23.004-4.08l3.688 11.496-8.851-11.497h5.163m9.301 11.497l3.305-10.306.383-1.196h5.168l-5.641 7.332-3.215 4.175M26.412 3.09l2.595 8.093h-5.189l2.594-8.093M20.97 13.26l-3.05 9.511-1.264 3.94-4.312-13.45h8.626M6.896 3.09l2.6 8.093h-5.19l2.59-8.093M2.18 18.172a.177.177 0 01-.058-.192l1.141-3.553 8.07 10.49-9.153-6.74m28.948 0l-9.153 6.737.353-.46 7.718-10.022 1.14 3.551a.18.18 0 01-.058.194" fill="#ffffff" fill-rule="nonzero"/></svg>"""

