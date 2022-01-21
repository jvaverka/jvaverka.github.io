+++
title = "Free As In Beer"
descr = "My take on Free and Libre Open Source Software and who it can benefit."
rss = "My take on Free and Libre Open Source Software and who it can benefit."
date = Date(2022, 1, 16)
hascode = true
tags = ["life", "linux"]
+++

{{ posttags }}

## Free As In Beer

\toc

### GNU / Linux

Linux (or GNU/Linux) is a free and open-source operating system that I started
using around 2018. Actually, my first encounter was in 2016, but I was a mere
philistine who couldn't comprehend its relevance. Not coincidentally,
re-introduction corresponded with my joining a high-powered development team.
Embracing Linux (and open-source software in general) revealed a new perspective
on what was possible on computers.

However, there is some good news and some bad news. Such is life.

### Bad News

Now, there is an old adage:

> Linux is only free if your time has no value.[^linux]

I.e., prepare yourself for a time-sink.

I believe most Linux users would concede this point.[^but] The learning curve
is real, it can be steep, and only the committed among us survive the journey
to reap the reward.

While we're at it, let's gripe a bit:

:grapes: Terminals are scary (at first)[^term]

:grapes: Hardware support not guaranteed \*cough\* GPUs & Bluetooth

:grapes: Foot-guns are a thing

What's a _foot-gun_ you ask. Let me demonstrate.

#### Dependency Hell

![world-of-pain](./world-of-pain.jpg)

Never heard of [`harfbuzz`](https://harfbuzz.github.io/)? Me neither until I
thought ligatures were a real terminal necessity. Don't know what ligatures
are? Maybe your better off not knowing.[^jk] Gross over simplification -
`harfbuzz` is a library needed for ligatures. No problem - there's a build
section in the library docs, and after my first `meson build` I have my
ligatures!

I'm pretty pleased until some time later upon realizing that several other
programs depend on this library and are now failing. One solution proposed on
Arch Wiki was to set the `LD_PRELOAD` environment variable to help each program
find its preferred library. Kind of a hack-y band aid, but it got me unstuck and
working again. "Flipping" this additional switch was fine until I ran across
programs that failed no matter which way the switch was flipped. Finally, I was
forced to confront the real problem.

The solution - do another `meson build` with an additional flag that was needed
for my particular system and which was not well documented. This was painful.
When you're navigating uncharted waters, it's unclear where the danger will be
lurking. However, that does *NOT* mean that you should be scared to explore.
This bout frustrated me at times, but I learned about `harfbuzz` and why
programs like `Libre Office` and `Pandoc` rely on it.

Anyone who gets started with Linux will find their own unique _*Harfbuzz Hell*_
because each user will customize their machine to their liking for their
functions. So best advise is embrace it and look for the learning opportunities.
They are plentiful.

### Good News

Congratulations for making it to the good news (we're almost done here). In
keeping with the theme, here is another obscure quote.

> To like only for some future goal is shallow. It's the sides of the mountain
> which sustain life, not the top. Here's where things grow.[^zen]

Diving into the unknown and keeping an open mind will reveal many treasures. So
many brilliant people have worked hard on a project and selflessly shared the
end product. There's really no _need_ to pay for an operating system or any
software if you don't want to. A little exploration will prove this, and those
things which seemed scary will turn out to be over-sized teddy bears.

There's too many to count, but here are some things I appreciate:

- :blue_heart: Terminals ⇒ beautifully simple command line tools[^cli]
- :blue_heart: Open-source ⇒ constant innovations
- :blue_heart: Freedom (as in speech) ⇒ customize everything[^de]
- :blue_heart: Shell ⇒ script automate everything
- :blue_heart: Options ⇒ for those who want better

## Conclusion

![opinion](./opinion.jpg)

Things can be free, as in beer[^free], as in costs no money. Or things can be
free, as in speech, as in do whatever you want just leave me out of it. There's
many cases of both throughout Linux and the wider Open-source community.

Sound good? Remember, anyone can do this and there is nothing to lose.

If you want to save a buck on expensive software, then try. If you don't like
it, then go back to your comfort zone. You'll be more educated for trying.

If you are the type that wants to know your machine, understand how it works,
and how to fix it yourself when it doesn't, then you will be right at home.

Share this with a curious soul or anyone asking about Linux.

### References

[^linux]: [Jamie Zawinski](https://www.brainyquote.com/quotes/jamie_zawinski_320496)
[^but]: See the [Good News](/posts/free-as-in-beer#good_news)
[^term]: You learn to love them. As I write this there are 8 on my system.
[^jk]: Just kidding, they're awesome ⇒ ⇗ ⇑ ⇖ ⇐ ⇙ ⇓ ⇘ ⇒ α ≥ β ≤ γ ≠ δ ⬖
[^zen]: From [Zen and the Art of Motorcycle Maintenance](https://www.goodreads.com/book/show/629.Zen_and_the_Art_of_Motorcycle_Maintenance)
[^cli]: [awesome-cli-apps](https://github.com/agarrharr/awesome-cli-apps)
[^de]: [Desktop Environments](https://itsfoss.com/best-linux-desktop-environments/)
[^free]: [Gratis versus libre](https://en.wikipedia.org/wiki/Gratis_versus_libre)
