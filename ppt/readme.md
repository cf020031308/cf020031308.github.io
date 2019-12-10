# About

This is a tool based on [reveal.js](https://github.com/hakimel/reveal.js) to convert online markdown files into slides if you place the URL (whether absolute or relative)  at the search part like this:

[https://cf020031308.github.io/ppt?/notes/english/20190502.md](?/notes/english/20190502.md)

To see more please scroll up or press right/down key .


The markdown file is retrieved and parsed, and then is splitted into slides by "`---`" or three consecutive newlines and into sub-slides by "`___`" or two.

To see more please scroll left or press right/down key .


## Embedding Your Awesome Data

Utilizing [echarts](https://www.echartsjs.com) and [mermaid](https://mermaid-js.github.io) you may write down your data as it is like this:

<div class="cols">

    ```echarts
    *\\Air Quality:Beijing,Shanghai,Guangzhou,Shenzhen,Hangzhou,Chengdu,Wuhan
    AQI,55,25,56,33,82,42,74
    PM2.5,9,11,7,7,58,24,49
    PM10,56,21,63,29,90,44,77
    CO,0.46,0.65,0.3,0.33,1.77,0.76,1.46
    NO2,18,34,14,16,68,40,48
    SO2,6,9,5,6,33,16,27
    ```

or

    ```echarts
    Request Trend by Channels
     Direct:335
     *Mail:310
     Moba:274
     *Vedio:85
     Search Engine:400
    ```

</div>


And your data will turn into interactive charts like this:

<div class="cols">

```echarts
*\\Air Quality:Beijing,Shanghai,Guangzhou,Shenzhen,Hangzhou,Chengdu,Wuhan
AQI,55,25,56,33,82,42,74
PM2.5,9,11,7,7,58,24,49
PM10,56,21,63,29,90,44,77
CO,0.46,0.65,0.3,0.33,1.77,0.76,1.46
NO2,18,34,14,16,68,40,48
SO2,6,9,5,6,33,16,27
```

and

```echarts
Request Trend by Channels
 Direct:335
 *Mail:310
 Moba:274
 *Vedio:85
 Search Engine:400
```

</div>


Check [Data Conversion](/ppt/?/ppt/chart.md) to learn more.


## Troubleshooting

* To pass the CORS policy You need to download [the source code of this page](https://github.com/cf020031308/cf020031308.github.io/raw/master/ppt/index.html) to your local path to open.



## [Comment](https://github.com/cf020031308/cf020031308.github.io/issues/15)
