# Rencontre de Jeunesse

![deployed version](https://hodor.rencontredejeunesse.ch/api/tags/rencontredejeunesse?format=svg)
[![rencontredejeunesse.ch deploy](https://github.com/doxa-tech/rencontredejeunesse/actions/workflows/rj_deploy.yml/badge.svg)](https://github.com/doxa-tech/rencontredejeunesse/actions/workflows/rj_deploy.yml)

Sources of [https://rencontredejeunesse.ch/](https://rencontredejeunesse.ch/).

# Introduction for DEVs

The RJ website is a static website built with [Astro](https://astro.build/) and
a React integration for handling dynamic content.

We use Astro for the following:

- templating: organize the website into layouts, pages, and components
- CSS rendering: write styles using SASS and automatically scope/organize them to layouts/pages/components

We use React for the following:

- Handle dynamic content on pages such as menu or slideshow

And not much else. The nice thing about Astro is its flexibility. Despite its
ability to offer an extensive set of functionalities, we use it for only what we
need.

## General guidelines

We try to stay consistent in how we organize, structure, and write code. It is
always a good idea to first have a look around the existing code before writing
new one. New code should be indistinguishable from the old one (think about
formatting, variable names, structure, css organization, etc...).

Code should be built with **maintenance** in mind. Code we write can last for
years and will be touched by others. Especially, the code should be easy to
understand for others and easily updatable. This is why consistency is key.

## Pages and components

We organize the website as follow:

- Each page is defined in `src/pages/<my_page>.astro`
- A page is made of **components** that are defined in `src/components/<my_page>/<my_component>.astro`

A **component** is a self-contained portion of HTML and CSS that can be included
on a page. Components are the building blocks of pages. For example, a page with
a banner, a row containing two cells, and a form, would have 3 components
stacked: the banner, the row, and the form.

The definition of a page mainly consist of stacking a list of components. For
example, the home page (defined in `scr/pages/index.astro`) is defined as
follow:

```astro
<Layout title="RJ - Rencontre de Jeunesse">
	<section>
		<Welcome />
		<Twotiles />
		<Vision />
		...
	</section>
</Layout>

<style lang="scss">
	section {
		min-height: 100%;
	}
</style>
```

In this example, `Welcome`, `Twotiles`, etc... Are all self-contained components
that will be included on the home page by Astro. Components of the home page are
defined in `scr/components/home/`.

Here is an example of a component:

```astro
<section>
  <div class="section-container">
    <p class="hi">Hello, world</p>
  </div>
</section>

<style lang="scss">
  section {
    .section-container {
      p.hi {
        font-style: italic;
      }
    }
  }
</style>
```

In summary, **pages**, which mainly stack components, are defined in
`src/pages`, and **components**, which are the building blocks of pages, are
defined in `src/components/<page>/`:

```
src/
├─ components/
│  ├─ page1/
│  │  ├─ compomentA.astro
│  │  ├─ componentB.astro
│  │  ├─ ...
│  ├─ page2/
├─ pages/
│  ├─ page1.astro
│  ├─ page2.astro
│  ├─ ...
```

It can happen that a component is general enough to be used by multiple pages.
In this case the component is defined in `scr/components`.

## Layout

A **layout** defines the common frame for pages. Layouts are defined in
`scr/layouts`. A layout can use components, which are defined in the same
folder.

## Style

- We use SASS
- class names must use kebab-case: `.section-container` and NOT `.section_container` NOR `.sectionContainer`.
- Each component defines its own style with a `<style lang="scss">` directive.
- Global css can be defined in `scr/styles` and must be included in the layout.
- Pages can also define their own styles, but note that their components won't inherit them.
- SASS allows to use variables. It is a good idea to define them in a global stylesheet that we import in each component.

## Dynamic components

By default Astro renders everything as static pages. To build dynamic component
we use `React`. A dynamic component is defined as a regular component, but with
the extension `*React.tsx`, and it is included with the directive:
`client:visible`:. In the case of react, the CSS is defined in a file
`*module.scss`. 

In some cases, it is more suitable to define the component as a regular static
component, and make it include the dynamic part. In summary:

```
src/
├─ components/
│  ├─ page1/
│  │  ├─ compomentA.astro
│  │  ├─ componentB.astro
│  │  ├─ componentC.astro # include the one bellow
│  │  ├─ componentCReact.tsx
│  │  ├─ componentCReact.module.scss
```

## Build and run

Dev: `npm run dev`.