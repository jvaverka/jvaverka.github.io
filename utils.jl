using Dates
using Franklin
using Weave

function hfun_bar(vname)
    val = Meta.parse(vname[1])
    return round(sqrt(val); digits=2)
end

function hfun_m1fill(vname)
    var = vname[1]
    return Franklin.pagevar("index", var)
end

function lx_baz(com, _)
    # keep this first line
    brace_content = Franklin.content(com.braces[1]) # input string
    # do whatever you want here
    return uppercase(brace_content)
end

function hfun_eval(arg)
    x = Core.eval(Franklin, Meta.parse(join(arg)))
    io = IOBuffer()
    show(io, "text/plain", x)
    return String(take!(io))
end

function write_posts(rpaths)::String
    sort_posts!(rpaths)
    curyear = Dates.year(Franklin.pagevar(rpaths[1], :date))
    io = IOBuffer()
    write(io, "<h3 class=\"posts\">$curyear</h3>")
    write(io, "<ul class=\"posts\">")
    for rp in rpaths
        year = Dates.year(Franklin.pagevar(rp, :date))
        if year < curyear
            write(io, "<h3 class=\"posts\">$year</h3>")
            curyear = year
        end
        title = Franklin.pagevar(rp, :title)
        descr = Franklin.pagevar(rp, :descr)
        descr === nothing && error("no description found on page $rp")
        pubdate = Dates.format(Date(Franklin.pagevar(rp, :date)), "U d")
        path = joinpath(splitpath(rp)[1:2]...)
        write(
            io,
            """
      <li class="post">
          <p>
              <span class="post">$pubdate</span>
              <a href="/$path/">$title</a>
              <span class="post-descr tag">$descr</span>
          </p>
      </li>
      """,
        )
    end
    write(io, "</ul>")  #= posts =#
    return String(take!(io))
end

function sort_posts!(rpaths)
    sorter(p) = begin
        pvd = Franklin.pagevar(p, :date)
        if isnothing(pvd)
            return Date(Dates.unix2datetime(stat(p * ".md").ctime))
        end
        return pvd
    end
    return sort!(rpaths; by=sorter, rev=true)
end

function hfun_allposts()::String
    rpaths = [
        joinpath("posts", post, "index.md") for
        post in readdir("posts") if !endswith(post, ".md")
    ]
    return write_posts(rpaths)
end

Franklin.@delay function hfun_alltags()
    tagpages = Franklin.globvar("fd_tag_pages")
    if tagpages === nothing
        return ""
    end
    tags = sort(collect(keys(tagpages)))
    tags_count = [length(tagpages[t]) for t in tags]
    io = IOBuffer()
    write(io, "<div class=\"tag-container\">")
    for (t, c) in zip(tags, tags_count)
        write(
            io,
            """
      <div class="tag">
        <nobr>
        <a class="tag" href="/tag/$t/">$(replace(t, "_" => " "))</a>
        <span class="tag"> ($c)</span>
        </nobr>
      </div>
      """,
        )
    end
    write(io, "</div>")  #= tag-container =#
    return String(take!(io))
end

function hfun_taglist()
    tag = Franklin.locvar(:fd_tag)::String
    rpaths = Franklin.globvar("fd_tag_pages")[tag]
    return write_posts(rpaths)
end

function hfun_weave2html(document)
    f_name = tempname(pwd()) * ".html"
    weave(first(document); out_path=f_name)
    text = read(f_name, String)
    final = x ->
        replace(x, r"<span class='hljl-.*?>" => "") |> # Removes weave code block syntax
        x ->
            replace(x, "</span>" => "") |> # Removes weave code block syntax
            x ->
                replace(
                    x,
                    "<pre class='hljl'>\n" => "<pre><code class = \"language-julia\">", # Replaces weave code block syntax with Franklin's
                ) |> x -> replace(x, "</pre>" => "</code></pre>")("<!DOCTYPE html>\n<HTML lang = \"en\">" *
                                                                  split(text, "</HEAD>")[2]) # Replaces weave code block syntax with Franklin's
    rm(f_name)
    return final
end

Franklin.@delay function hfun_posttags()
    pagetags = Franklin.globvar("fd_page_tags")
    pagetags === nothing && return ""
    io = IOBuffer()
    tags = sort(collect(pagetags[splitext(Franklin.locvar("fd_rpath"))[1]]))
    write(io, """<div class="tag"><i class="fa fa-tag"></i>""")
    for tag in tags[1:(end - 1)]
        t = replace(tag, "_" => " ")
        write(io, """<a href="/tag/$tag/">$t</a>, """)
    end
    tag = tags[end]
    t = replace(tag, "_" => " ")
    write(io, """<a href="/tag/$tag/">$t</a></div>""")
    return String(take!(io))
end

function hfun_socialicons()
    io = IOBuffer()
    write(
        io,
        """
    <div class="social-container">
        <div class="social-icon">
            <a href="/posts/" title="blog">
                <i class="fa fa-pencil"></i>
            </a>
        </div>
        <div class="social-icon">
            <a href="/about/" title="about">
                <i class="fa fa-user-circle-o"></i>
            </a>
        </div>
        <div class="social-icon">
            <a href="/feed.xml" title="rss">
                <i class="fa fa-rss"></i>
            </a>
        </div>
        <div class="social-icon">
            <a href="https://www.linkedin.com/in/jacob-vaverka-b5965052" title="linkedin">
                <i class="fa fa-linkedin"></i>
            </a>
        </div>
        <div class="social-icon">
            <a href="https://github.com/jvaverka" title="github">
                <i class="fa fa-github"></i>
            </a>
        </div>
        <div class="social-icon">
            <a href="https://gitlab.com/jvaverka" title="gitlab">
                <i class="fa fa-gitlab" aria-hidden="false"></i>
            </a>
        </div>
    </div>
""",
    )
    return String(take!(io))
end

"""
    newpost(;title::String, descr::String, tags::Vector{String}, code=false)
"""
function newpost(;title::String, descr::String, tags::Vector{String}, code=false)
    path = joinpath(@__DIR__, "posts", replace(lowercase(title), " " => "-"))
    post = joinpath(path, "index.md")
    mkpath(path)
    touch(post)
    y = Dates.year(Dates.today())
    m = Dates.month(Dates.today())
    d = Dates.day(Dates.today())
    open(post, "w") do io
        write(io, """
        +++
        title = "$title"
        descr = "$descr"
        rss = "$descr"
        date = Date($y, $m, $d)
        hascode = $code
        tags = $(sort(tags))
        +++

        {{ posttags }}

        ## $title

        \\toc

        ### Subtitle
        """)
    end
end
