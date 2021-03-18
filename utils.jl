function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

function hfun_bloglist()::String
    # -----------------------------------------
    # Part1: Retrieve all pages associated with
    #  the tag & sort them
    # -----------------------------------------
    # retrieve the tag string
#   tag = locvar(:fd_tag)
    # tag = "tag/blog/"
    # recover the relative paths to all pages that have that
    # tag, these are paths like /blog/page1
#   rpaths = globvar("fd_tag_pages")[tag]
    rpaths = readdir(joinpath(@__DIR__, "blog"))
    # you might want to sort these pages by chronological order
    # you could also only show the most recent 5 etc...
    sorter(p) = begin
        # retrieve the "date" field of the page if defined, otherwise
        # use the date of creation of the file
        pvd = pagevar(p, :date)
        if isnothing(pvd)
            return Date(Dates.unix2datetime(stat(p * ".md").ctime))
        end
        return pvd
    end
    sort!(rpaths, by=sorter, rev=true)

    # --------------------------------
    # Part2: Write the HTML to plug in
    # --------------------------------
    # instantiate a buffer in which we will write the HTML
    # to plug in the tag page
    c = IOBuffer()
    write(c, "<ul>")
    # go over all paths
    for rpath in rpaths
        # recover the url corresponding to the rpath
        url = get_url(rpath)
        # recover the title of the page if there is one defined,
        # if there isn't, fallback on the path to the page
        title = pagevar(rpath, "title")
        if isnothing(title)
            title = "/$rpath/"
        end
        # write some appropriate HTML
        write(c, "<li><a href=\"/$rpath/\">$title</a></li>")
    end
    # finish the HTML
    write(c, "</ul>")
    # return the HTML string
    return String(take!(c))
end
