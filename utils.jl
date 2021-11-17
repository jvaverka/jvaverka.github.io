using Dates
using Franklin
using Weave

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

function write_notes(rpaths)::String
    sort_notes!(rpaths)
    curyear = Dates.year(Franklin.pagevar(rpaths[1], :date))
    c = IOBuffer()
    write(c, "<h3 class=\"notes\">$curyear</h3>")
    write(c, "<ul class=\"notes\">")
    for rp in rpaths
        year = Dates.year(Franklin.pagevar(rp, :date))
        if year < curyear
            write(c, "<h3 class=\"notes\">$year</h3>")
            curyear = year
        end
        title = Franklin.pagevar(rp, :title)
        descr = Franklin.pagevar(rp, :descr)
        descr === nothing && error("no description found on page $rp")
        pubdate = Dates.format(Date(Franklin.pagevar(rp, :date)), "U d")
        path = joinpath(splitpath(rp)[1:2]...)
        write(c, """
            <li class="note">
                <p>
                    <span class="note">$pubdate</span>
                    <a href="/$path/">$title</a>
                    <span class="note-descr tag">$descr</span>
                </p>
            </li>
            """)
    end
    write(c, "</ul>")  #= notes =#
    return String(take!(c))
end

function sort_notes!(rpaths)
    sorter(p) = begin
        pvd = Franklin.pagevar(p, :date)
        if isnothing(pvd)
            return Date(Dates.unix2datetime(stat(p * ".md").ctime))
        end
        return pvd
    end
    return sort!(rpaths, by=sorter, rev=true)
end

function hfun_allnotes()::String
    rpaths = [joinpath("notes", note, "index.md") for note in readdir("notes") if !endswith(note, ".md")]
    return write_notes(rpaths)
end

# display all tags and their count
Franklin.@delay function hfun_alltags()
    tagpages = Franklin.globvar("fd_tag_pages")
    if tagpages === nothing
        return ""
    end
    tags = tagpages |> keys |> collect |> sort
    tags_count = [length(tagpages[t]) for t in tags]
    io = IOBuffer()
    write(io, "<div class=\"tag-container\">")
    for (t, c) in zip(tags, tags_count)
        write(io, """
            <div class="tag">
              <nobr>
              <a class="tag" href="/tag/$t/">$(replace(t, "_" => " "))</a>
              <span class="tag"> ($c)</span>
              </nobr>
            </div>
            """)
    end
    write(io, "</div>")  #= tag-container =#
    return String(take!(io))
end

# doesn't need to be delayed because it's generated at tag generation, after everything else
function hfun_taglist()
    tag = Franklin.locvar(:fd_tag)::String
    items = Dict{Date,String}()
    rpaths = Franklin.globvar("fd_tag_pages")[tag]
    return write_notes(rpaths)
    #= for rpath in Franklin.globvar("fd_tag_pages")[tag] =#
    #=     title = Franklin.pagevar(rpath, "title") =#
    #=     url = Franklin.get_url(rpath) =#
    #=     date = Date(Franklin.pagevar(rpath, :date)) =#
    #=     date_str = Dates.format(date, "U d, Y") =#
    #=     tmp = "* ~~~<span class=\"note tag\">$date_str</span><nobr><a href=\"$url\">$title</a></nobr>" =#
    #=     descr = Franklin.pagevar(rpath, :descr) =#
    #=     if descr !== nothing =#
    #=         tmp *= ": <span class=\"note-descr\">$descr</span>" =#
    #=     end =#
    #=     tmp *= "~~~\n" =#
    #=     items[date] = tmp =#
    #= end =#
    #= sorted_dates = sort!(items |> keys |> collect, rev=true) =#
    #= io = IOBuffer() =#
    #= write(io, "@@notes-container,mx-auto,px-3,py-5,list,mb-5\n @@notes\n") =#
    #= for date in sorted_dates =#
    #=     write(io, items[date]) =#
    #= end =#
    #= write(io, "@@\n @@") =#
    #= return Franklin.fd2html(String(take!(io)), internal=true) =#
end

# publish Julia Markdown documents directly in page
# `{{weave2html path/to/file.jmd}}`
# just don't forget to strip away Weave.jl generated head & foot
function hfun_weave2html(document)
    f_name = tempname(pwd()) * ".html"
    weave(first(document), out_path = f_name)
    text = read(f_name, String)
    final =
        "<!DOCTYPE html>\n<HTML lang = \"en\">" * split(text, "</HEAD>")[2] |> # Splits the weave document on the head block
        x -> replace(x, r"<span class='hljl-.*?>" => "") |> # Removes weave code block syntax
        x -> replace(x, "</span>" => "") |> # Removes weave code block syntax
        x -> replace(x,
            "<pre class='hljl'>\n" => "<pre><code class = \"language-julia\">", # Replaces weave code block syntax with Franklin's
        ) |> x -> replace(x, "</pre>" => "</code></pre>") # Replaces weave code block syntax with Franklin's
    rm(f_name)
    return final
end

# linkedin icon
const SVG_LINKEDIN = """<svg width="30" height="30" viewBox="0 50 512 512"><path fill="currentColor" d="M150.65 100.682c0 27.992-22.508 50.683-50.273 50.683-27.765 0-50.273-22.691-50.273-50.683C50.104 72.691 72.612 50 100.377 50c27.766 0 50.273 22.691 50.273 50.682zm-7.356 86.651H58.277V462h85.017V187.333zm135.901 0h-81.541V462h81.541V317.819c0-38.624 17.779-61.615 51.807-61.615 31.268 0 46.289 22.071 46.289 61.615V462h84.605V288.085c0-73.571-41.689-109.131-99.934-109.131s-82.768 45.369-82.768 45.369v-36.99z"/></svg>"""

# github icon
const SVG_GITHUB = """<svg width="30" height="30" viewBox="0 0 25 25" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"/></svg>"""

# gitlab icon
const SVG_GITLAB = """<svg width="34" height="30" xmlns="http://www.w3.org/2000/svg"><path d="M33.164 17.346l-1.742-5.42c-.002-.006 0-.012 0-.017L27.965 1.125A1.638 1.638 0 0026.41 0h-.01a1.626 1.626 0 00-1.541 1.135l-3.222 10.048h-9.96L8.452 1.136A1.627 1.627 0 006.908 0H6.9a1.64 1.64 0 00-1.558 1.136L1.9 11.896l-.008.014-1.746 5.436a2.248 2.248 0 00.803 2.5l15.085 11.108c.038.027.08.04.12.06.008.005.012.012.02.018l.014.005c.012.006.025.01.037.015.01.004.019.01.028.015l.012.006c.044.018.089.033.136.045.023.006.046.006.07.011.06.01.12.027.18.027.024 0 .047-.012.072-.014.072-.006.145-.016.217-.037.013-.004.028-.003.042-.007.01-.003.017-.01.026-.012.027-.01.052-.022.078-.034l.038-.015.013-.005c.018-.01.03-.026.047-.037.028-.016.06-.026.087-.044l.004-.003L32.36 19.846a2.248 2.248 0 00.804-2.5m-23.004-4.08l3.688 11.496-8.851-11.497h5.163m9.301 11.497l3.305-10.306.383-1.196h5.168l-5.641 7.332-3.215 4.175M26.412 3.09l2.595 8.093h-5.189l2.594-8.093M20.97 13.26l-3.05 9.511-1.264 3.94-4.312-13.45h8.626M6.896 3.09l2.6 8.093h-5.19l2.59-8.093M2.18 18.172a.177.177 0 01-.058-.192l1.141-3.553 8.07 10.49-9.153-6.74m28.948 0l-9.153 6.737.353-.46 7.718-10.022 1.14 3.551a.18.18 0 01-.058.194" fill="#004de6" fill-rule="nonzero"/></svg>"""

# tag icon
hfun_svg_tag() = """<a href="/tags/" id="tag-icon"><svg width="20" height="20" viewBox="0 0 512 512"><defs><style>.cls-1{fill:#141f38}</style></defs><path class="cls-1" d="M215.8 512a76.1 76.1 0 0 1-54.17-22.44L22.44 350.37a76.59 76.59 0 0 1 0-108.32L242 22.44A76.11 76.11 0 0 1 296.2 0h139.2A76.69 76.69 0 0 1 512 76.6v139.19A76.08 76.08 0 0 1 489.56 270L270 489.56A76.09 76.09 0 0 1 215.8 512zm80.4-486.4a50.69 50.69 0 0 0-36.06 14.94l-219.6 219.6a51 51 0 0 0 0 72.13l139.19 139.19a51 51 0 0 0 72.13 0l219.6-219.61a50.67 50.67 0 0 0 14.94-36.06V76.6a51.06 51.06 0 0 0-51-51zm126.44 102.08A38.32 38.32 0 1 1 461 89.36a38.37 38.37 0 0 1-38.36 38.32zm0-51a12.72 12.72 0 1 0 12.72 12.72 12.73 12.73 0 0 0-12.72-12.76z"/><path class="cls-1" d="M217.56 422.4a44.61 44.61 0 0 1-31.76-13.16l-83-83a45 45 0 0 1 0-63.52L211.49 154a44.91 44.91 0 0 1 63.51 0l83 83a45 45 0 0 1 0 63.52L249.31 409.24a44.59 44.59 0 0 1-31.75 13.16zm-96.7-141.61a19.34 19.34 0 0 0 0 27.32l83 83a19.77 19.77 0 0 0 27.31 0l108.77-108.7a19.34 19.34 0 0 0 0-27.32l-83-83a19.77 19.77 0 0 0-27.31 0l-108.77 108.7z"/><path class="cls-1" d="M294.4 281.6a12.75 12.75 0 0 1-9-3.75l-51.2-51.2a12.8 12.8 0 0 1 18.1-18.1l51.2 51.2a12.8 12.8 0 0 1-9.05 21.85zM256 320a12.75 12.75 0 0 1-9.05-3.75l-51.2-51.2a12.8 12.8 0 0 1 18.1-18.1l51.2 51.2A12.8 12.8 0 0 1 256 320zM217.6 358.4a12.75 12.75 0 0 1-9-3.75l-51.2-51.2a12.8 12.8 0 1 1 18.1-18.1l51.2 51.2a12.8 12.8 0 0 1-9.05 21.85z"/></svg></a>"""

Franklin.@delay function hfun_page_tags()
    pagetags = Franklin.globvar("fd_page_tags")
    pagetags === nothing && return ""
    io = IOBuffer()
    tags = pagetags[splitext(Franklin.locvar("fd_rpath"))[1]] |> collect |> sort
    write(io, """<div class="tags">$(hfun_svg_tag())""")
    for tag in tags[1:end-1]
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
    write(io, """
        <div class="social-container">
            <div class="social-icon">
                <a href="https://github.com/jvaverka" title="github">
                    $(SVG_GITHUB)
                </a>
            </div>
            <div class="social-icon">
                <a href="https://www.linkedin.com/in/jacob-vaverka-b5965052" title="linkedin">
                    $(SVG_LINKEDIN)
                </a>
            </div>
            <div class="social-icon">
                <a href="https://gitlab.com/jvaverka" title="gitlab">
                    $(SVG_GITLAB )
                </a>
            </div>
        </div>
    """)
    return String(take!(io))
end
