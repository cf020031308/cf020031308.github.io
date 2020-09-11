# Flex 与 Grid 布局

## [Flex 布局](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

```css
.container {
  display: flex | inline-flex;

  flex-flow: flex-direction flex-wrap;
  flex-direction: row | row-reverse | column | column-reverse;
  flex-wrap: nowrap | wrap | wrap-reverse;  /* whether fit into one line or more */

  justify-content: flex-start | flex-end | center | space-between | space-around | space-evenly;  /* main axis */
  align-content: flex-start | flex-end | center | stretch | space-between | space-around;  /* cross axis */
  align-items: flex-start | flex-end | center | stretch | baseline;
}

.item {
  order: 0;

  flex: flex-grow flex-shrink flex-basis;
  flex-grow: 0;
  flex-shrink: 1;
  flex-basis: auto | 20%;

  align-self: auto | flex-start | flex-end | center | baseline | stretch;
}
```

## [Grid 布局](https://css-tricks.com/snippets/css/complete-guide-grid/)

```css
.container {
  display: grid | inline-grid;

  grid-template-columns: [first] 1fr 40px auto [col-line4] 20%;
  grid-template-rows: 40 30px [row-line3] 20%;
  grid-template-areas:
    "header header header header"
    "main main . sidebar"
    "footer footer footer footer";  /* . is empty */

  grid-template:
    [first] "header header header header" 40
    "main main . sidebar" 30px
    "footer footer footer footer" 20%
    / [first] 1fr 40px auto [col-line4] 20%;

  gap: grid-gap;
  grid-gap: row-gap column-gap;
  row-gap: 0;
  column-gap: 0;

  place-items: align-items / justify-items;
  align-items: start | end | center | stretch;  /* column axis */
  justify-items: start | end | center | stretch;  /* row axis */

  place-content: align-content / justify-content;
  align-content: start | end | center | stretch | space-around | space-between | space-evenly;  /* column axis */
  justify-content: start | end | center | stretch | space-around | space-between | space-evenly;  /* row axis */
}

.item {
  grid-column: grid-column-start / grid-column-end
  grid-column-start: first;
  grid-column-end: col-line4;

  grid-row: grid-row-start / grid-row-end;
  grid-row-start: 1;
  grid-row-end: 2;

  grid-area: main;

  place-self: align-self / justify-self;
  align-self: start | end | center | stretch;
  justify-self: start | end | center | stretch;
}
```
