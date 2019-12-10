var decode_entity = function(s) {
    return s.replace(
        /&(amp|gt|lt);/g,
        function(w) {return {"&amp;": "&", "&gt;": ">", "&lt;": "<"}[w]; });
}

var split1 = function(str, sep) {
    var idx = str.indexOf(sep);
    if (idx === -1) return [str.trim()];
    return [str.substr(0, idx).trim(), str.substr(idx + sep.length).trim()];
};

var split = function(str, sep) {
    return str.split(sep).map(function(w) { return w.trim(); });
}

var isNum = function(n) {
    if (n.length === 0) return false;
    if ((n - 0) === (n - 0)) return true;
    return false;
}

var echartsOpt = function(str) {
    var option = Object.assign({
        sourceCode: str,
        backgroundColor: 'transparent',
        grid: { containLabel: true },
        tooltip: { confine: true },
        toolbox: {
            bottom: 'bottom',
            feature: {
                dataView: {
                    optionToContent: function(opt) {
                        return (
                            '<textarea style="width: 100%; height: 100%;">'
                            + opt.sourceCode
                            + '</textarea>'
                        );
                    },
                    readOnly: true,
                },
                saveAsImage: {},
            },
        },
    }, _echartsOpt(str));
    console.log(option);
    return option;
};

var _echartsOpt = function(str) {
    /**
     * if (lines.length === 1) Pyramid
     * else if (headcell.indexOf('\\') > -1) Table
     * else if (lines[1][0] === ' ') Tree
     * else if (headcell.indefOf(':') === -1) Points
     * else Graph
     **/
    var lines = str.trim().split(/\r?\n/);
    var arr = split1(lines[0], ':');
    if (lines.length === 1) {
        // Funnel or Pyramid
        var titlePos = 'top', sort = 'descending', data = [];
        if (arr[1].indexOf('>') > -1) {
            data = split(arr[1], '>');
        } else {
            sort = 'ascending';
            data = split(arr[1], '<').reverse();
            titlePos = 'bottom';
        }
        data = data.map(function(name, i) {return {name: name, value: data.length - i}});
        return {
            title: { text: arr[0], left: 'center', top: titlePos },
            tooltip: { show: false },
            series: [{
                type: 'funnel',
                label: { position: 'inner' },
                sort: sort,
                data: data,
            }],
        };
    } else if (arr[0].indexOf('\\') > -1) {
        // Table: Parallel, Radar or Barline
        var axis = split(arr[0], '\\');
        var title = axis[axis.length - 1];

        // parse csv
        var rows = [], xAxis = [], hasStr = new Array(lines.length - 1);
        for (var i = 1; i < lines.length; i++) {
            var row = split(lines[i], ',');
            xAxis.push(row[0]);
            rows.push(row.slice(1).map(function(n, j) {
                var m = n - 0;
                if (m === m) return m;
                hasStr[i - 1] = true;
                return n;
            }));
        }
        var series = [], col = 0, yAxisIndex = 0, stack = undefined;
        arr[1].replace(/[^,+|]+|[,+|]/g, function(w) {
            var serie = {};
            if (w === '+') {
            } else if (w === ',') {
                stack = undefined;
            } else if (w === '|') {
                stack = undefined;
                yAxisIndex = (yAxisIndex + 1) % 2;
            } else {
                var type = {'.': 'scatter', '-': 'line'}[w[0]];
                if (type) w = w.substr(1);
                else type = 'bar';
                stack = stack || w;
                series.push({
                    type: type,
                    name: w,
                    stack: stack,
                    yAxisIndex: yAxisIndex,
                    data: rows.map(function(row) { return row[col]; }),
                });
                col++;
            }
        });

        // Parallel
        if (hasStr.some(function(flag) { return flag; })
                || (axis[0] === '*' && rows.length <= 2)) {
            return {
                title: { text: title, left: 'center' },
                legend: { left: 'left', top: 'center', icon: 'line', orient: 'vertical', },
                parallelAxis: xAxis.map(function(name, i) {
                    return {dim: i, name: name, type: hasStr[i] ? 'category' : 'value' };
                }),
                parallel: { left: '15%', parallelAxisDefault: { nameLocation: 'start' } },
                series: series.map(function(serie) { return {
                    type: 'parallel',
                    name: serie.name,
                    data: [serie.data],
                        lineStyle: { normal: { opacity: 1 } },
                }; }),
            };
        }

        // Radar
        if (axis[0] === '*') {
            return {
                title: { text: title },
                legend: { right: 'right', icon: 'diamond', orient: 'vertical', },
                radar: {
                    indicator: xAxis.map(function(name) { return {name: name}; }),
                    splitArea: {show: false},
                    splitLine: {show: false},
                },
                series: series.map(function(serie) { return {
                    type: 'radar',
                    name: serie.name,
                    data: [{name: serie.name, value: serie.data}],
                }; }),
            };
        }

        // Barline
        return {
            title: { text: title, left: 'center' },
            legend: { type: 'scroll', top: '10%' },
            tooltip: { trigger: 'axis', confine: true },
            xAxis: {
                type: 'category',
                boundaryGap: series.some(function(serie) {return serie.type !== 'line'}),
                name: axis[0],
                data: xAxis,
            },
            yAxis: split(axis[1], '|').map(function(name) { return {
                name: name,
                splitLine: { show: false },
            }; }),
            series: series.map(function(serie) {
                if (serie.type === 'line' && series.find(function(s) {
                    return s.stack === serie.stack && s.name !== serie.name;
                })) serie.areaStyle = {};
                return serie;
            }),
        };
        return opt;
    } else if (lines[1][0] === ' ') {
        // Tree: Pie, Tree, Sunburst

        // parse tree
        var nodes = [];
        lines.forEach(function(line, i) {
            var indent = line.length - line.trimLeft().length;
            var arr = split1(line, ':');
            var name = arr[0];
            var selected = name[0] === '*';
            var node = {
                indent: indent,
                depth: 0,
                parent: nodes.find(function(n) { return n.indent < indent; }),
                descendants: 0,
                children: [],
                name: name.substr(selected),
                value: arr[1],
                selected: selected,
            };
            nodes.splice(0, 0, node);
            if (node.parent && node.parent.children.push(node) === 1) {
                while (node.parent) {
                    if (node.parent.depth === node.depth) {
                        node.parent.depth++;
                    }
                    node = node.parent;
                    node.descendants++;
                }
            }
        });
        nodes.forEach(function(n) {
            delete n.parent;
            n.label = n.selected ? {
                fontWeight: 'bolder',
                borderWidth: 1,
                formatter: function(params) {
                    if (params.percent) return (
                        params.name
                        + ': ' + params.value
                        + '\n(' + params.percent + '%)'
                    );
                    if (params.value && isNum(params.value)) {
                        return params.name + ': ' + params.value;
                    }
                    return params.name;
                },
            } : {};
            if (n.depth === 0) {
                n.label.position = 'outside';
            } else {
                n.label.align = 'center';
            }
            n.symbolSize = Math.sqrt(n.descendants + 1) * 10;
        });
        var root = nodes.pop();

        if (nodes.some(function(n) {
            var nan = (n.value - 0) !== (n.value - 0);
            return n.depth === 0 ? (!n.value || nan) : (n.value && nan);
        })) {
            // Tree
            nodes.forEach(function(n) { n.label.color = '#f9f9f9'; });
            return {
                title: { text: root.name, subtext: root.value, left: 'center' },
                tooltip: {
                    formatter: function(params) {
                        var ret = '<h3>' + params.name + '</h3>';
                        if (params.value) return (
                            ret += '<p>' + params.value + '</p>'
                        );
                        return ret;
                    }
                },
                series: {
                    type: 'tree',
                    layout: 'radial',
                    initialTreeDepth: -1,
                    data: root.children.length === 1 ? root.children : [{
                        value: root.name,
                        symbolSize: root.symbolSize,
                        children: root.children,
                    }],
                }
            }
        } else if (nodes.every(function(n) { return n.depth === 0; })) {
            // Pie
            return {
                title: { text: root.name, subtext: root.value, left: 'center' },
                series: {
                    type: 'pie',
                    selectedMode: 'multiple',
                    selectedOffset: 15,
                    radius: [0, '50%'],
                    data: root.children,
                },
            };
        } else {
            // Sunburst
            nodes.forEach(function(n) {
                n.value = n.value ? (n.value - 0) : undefined;
            });
            var levels = [{}];
            var width = 60 / (3 - 0.5 ** (root.depth - 2));
            var start = 15;
            for (var i = 0; i < root.depth; i++) {
                levels.push({
                    r0: start + '%',
                    r: (start = parseInt(start + width)) + '%',
                });
                if (i > 0) width *= 0.5;
            }
            return {
                title: { text: root.name, subtext: root.value, left: 'center' },
                series: {
                    type: 'sunburst',
                    highlightPolicy: 'ancestor',
                    data: root.children,
                    levels: levels,
                }
            };
        };
    } else if (lines[1].indexOf(':') === -1) {
        // Points: Scatter
        // parse csv
        var columns = split(arr[1], ',');
        var cluster = [''], clusters = [];
        var totalRadius = 0;
        for (var i = 1; i < lines.length; i++) {
            var record = split(lines[i], ',');
            if (record.length === 1) {
                cluster = record;
                clusters.push(cluster);
                continue;
            } else if (i === 1) {
                clusters.push(cluster);
            }
            record = record.map(function(n) {
                var m = n - 0;
                return m === m ? m : n;
            });
            switch(record.length) {
                case 2: record.push(1);
                case 3: record.push('');
            }
            totalRadius += Math.sqrt(record[2]);
            cluster.push(record);
        }
        var scale = totalRadius / 666;
        return {
            title: { text: arr[0], left: 'center' },
            legend: clusters.length > 1 ? {
                formatter: function(name) { return name[0] === ' ' ? ' ' : name; },
                itemWidth: 14,
                top: 'bottom',
            } : undefined,
            xAxis: { name: columns[0], scale: true },
            yAxis: { name: columns[1], scale: true },
            series: clusters.map(function(cluster, i) { return {
                type: 'scatter',
                name: cluster[0] || (' ' + i),
                symbolSize: function (record, params) {
                    return Math.sqrt(record[2]) / scale;
                },
                tooltip: {
                    confine: true,
                    formatter: function(param) {
                        return (
                            '<table style="color: ' + param.color + '"><tr><td>'
                            + [3, 0, 1, 2].filter(function(i) {
                                return columns[i] !== undefined;
                            }).map(function(i) {
                                return columns[i] + '</td><td>' + param.data[i];
                            }).join('</td></tr><tr><td>')
                            + '</td></tr></table>'
                        );
                    },
                },
                label: { normal: {
                    show: true,
                    formatter: function (param) { return param.data[3]; }
                } },
                data: cluster.slice(1),
            }; }),
        };
    } else {
        // TODO: Graph: circle/layout or Sankey
    }
    return {};
}
