# Chart test

## Radar Chart

| *\\\\Air Quality | Beijing | Shanghai | Guangzhou | Shenzhen | Hangzhou | Chengdu | Wuhan |
|------------------|---------|----------|-----------|----------|----------|---------|-------|
| AQI              | 55      | 25       | 56        | 33       | 82       | 42      | 74    |
| PM2.5            | 9       | 11       | 7         | 7        | 58       | 24      | 49    |
| PM10             | 56      | 21       | 63        | 29       | 90       | 44      | 77    |
| CO               | 0.46    | 0.65     | 0.3       | 0.33     | 1.77     | 0.76    | 1.46  |
| NO2              | 18      | 34       | 14        | 16       | 68       | 40      | 48    |
| SO2              | 6       | 9        | 5         | 6        | 33       | 16      | 27    |

## Parallel Chart

| *\\\\Air Quality | Beijing | Shanghai  | Guangzhou | Shenzhen | Hangzhou | Chengdu | Wuhan  |
|------------------|---------|-----------|-----------|----------|----------|---------|--------|
| AQI              | 55      | 25        | 56        | 33       | 82       | 42      | 74     |
| PM2.5            | 9       | 11        | 7         | 7        | 58       | 24      | 49     |
| PM10             | 56      | 21        | 63        | 29       | 90       | 44      | 77     |
| CO               | 0.46    | 0.65      | 0.3       | 0.33     | 1.77     | 0.76    | 1.46   |
| NO2              | 18      | 34        | 14        | 16       | 68       | 40      | 48     |
| SO2              | 6       | 9         | 5         | 6        | 33       | 16      | 27     |
| Level            | Good    | Excellent | Good      | Bad      | Medium   | Bad     | Medium |

## Bar Chart

| Weekday\\Request\\Request Trend by Channels | Mail | Moba | Vedio Ads | Direct | Search Engine |
|---------------------------------------------|------|------|-----------|--------|---------------|
| Sunday                                      | 210  | 310  | 410       | 320    | 1320          |
| Monday                                      | 120  | 220  | 150       | 320    | 820           |
| Tuesday                                     | 132  | 182  | 232       | 332    | 932           |
| Wednesday                                   | 101  | 191  | 201       | 301    | 901           |
| Thursday                                    | 134  | 234  | 154       | 334    | 934           |
| Friday                                      | 90   | 290  | 190       | 390    | 1290          |
| Saturday                                    | 230  | 330  | 330       | 330    | 1330          |

## Barline Chart with scatters and stacks

| Weekday\\Request\\Request Trend by Channels | -Mail | +Moba | +Vedio Ads | +Direct | .Search Engine |
|---------------------------------------------|-------|-------|------------|---------|----------------|
| Sunday                                      | 210   | 310   | 410        | 320     | 1320           |
| Monday                                      | 120   | 220   | 150        | 320     | 820            |
| Tuesday                                     | 132   | 182   | 232        | 332     | 932            |
| Wednesday                                   | 101   | 191   | 201        | 301     | 901            |
| Thursday                                    | 134   | 234   | 154        | 334     | 934            |
| Friday                                      | 90    | 290   | 190        | 390     | 1290           |
| Saturday                                    | 230   | 330   | 330        | 330     | 1330           |

## Pie Chart

| \\request\\Request Trend by Channels | Direct | Mail | Moba | Vedio Ads | Search Engine |
|--------------------------------------|--------|------|------|-----------|---------------|
|                                      | 335    | 310  | 274  | 85        | 400           |

## Not Pie Chart

| channel\\Request Trend by Channels | request |
|------------------------------------|---------|
| Direct                             | 335     |
| Mail                               | 310     |
| Moba                               | 274     |
| Vedio Ads                          | 85      |
| Search Engine                      | 400     |

## Graphviz

```dot
digraph {
    a -> b;
}
```

```dot
digraph {
    rankdir=RL;
    x -> y;
}
```

## Mermaid

```mermaid
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail!
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!
```

```mermaid
gantt
dateFormat  YYYY-MM-DD
title Adding GANTT diagram to mermaid
excludes weekdays 2014-01-10

section A section
Completed task            :done,    des1, 2014-01-06,2014-01-08
Active task               :active,  des2, 2014-01-09, 3d
Future task               :         des3, after des2, 5d
Future task2               :         des4, after des3, 5d
```
