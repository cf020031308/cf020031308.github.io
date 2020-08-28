const M = {};

const toTable = M.toTable = (title, headers, lines) => [
  (title ? [headers[0] + '\\\\' + title, ...headers.slice(1)] : headers).join('|'),
  headers.map(_ => '-').join('|'),
  ...lines.map(line => line.join('|')),
].join('\n');

const sum = M.sum = arr => arr.reduce((s, x) => s + x, 0);
const conv = M.conv = (arr1, arr2) => arr1.map((x, i) => x * (arr2[i] || 0));
const rconv = M.rconv = (arr1, arr2) => arr1.map((x, i) => x * (arr2[arr2.length - 1 - i] || 0));
const range = M.range = (start, end, offset) => new Array(parseInt((end - start) / (offset || 1))).fill(start).map((x, i) => x + i * (offset || 1));

const ARMA = M.ARMA = (N, phis = [1], thetas = [1], mu = 0, sigma2 = 1) => {
  const M = Math;
  const sigma = M.sqrt(sigma2);
  let es = [], xs = [];
  for (let t = 0; t < N + 50; t++) {
    es.push(M.cos(2 * M.PI * M.random()) * M.sqrt(-2 * M.log(1 - M.random())) * sigma + mu);
    xs.push((sum(rconv(thetas, es.slice(0, t + 1))) - sum(rconv(phis.slice(1), xs.slice(0, t)))) / phis[0]);
  }
  return xs.slice(-N);
};

const corr = M.corr = (xs, K) => new Array(K + 1).fill(0).map((_, k) => sum(conv(xs, xs.slice(k))) / xs.length);
const iCorr = M.iCorr = (xs, p) => (i, j) => sum(conv(xs.slice(p - i, xs.length + 1 - i), xs.slice(p - j))) / xs.length;

const forecast = M.forecast = gs => {
  let hs = gs.map(() => [1]);
  for (let k = 1; k < gs.length; k++) {
    hs[k][k] = -sum(rconv(hs[k - 1], gs.slice(0, k + 1))) / sum(conv(hs[k - 1], gs));
    for (let j = 1; j < k; j++) hs[k][j] = hs[k - 1][j] + hs[k][k] * hs[k - 1][k - j];
  }
  return hs;
};

const parCorr = M.parCorr = hs => hs.map((h, k) => -h[k]).slice(1);

const newInfo = M.newInfo = gs => {
  let ts = [[]], vs = [gs[0]];
  for (let m = 1; m < gs.length; m++) {
    ts[m] = [1];
    for (let k = 0; k < m; k++)
      ts[m][m - k] = (gs[m - k] - sum(rconv(rconv(vs.slice(0, k), ts[m]), ts[k].slice(0, k + 1)))) / vs[k];
    vs[m] = gs[0] - sum(rconv(rconv(vs, ts[m]), ts[m]));
  }
  return [ts, vs];
};

const tMat = M.tMat = A => A[0].map((_, j) => A.map(r => r[j]));

const linSolve = M.linSolve = (A, B) => {
  const n = A[0].length;
  if (A.length < n) throw new Error('Singular Matrix');

  const bIsVec = !Array.isArray(B[0]);
  B = bIsVec ? tMat([B]) : B;
  let aug = A.map((row, i) => [...row, ...B[i]]);

  for (let i = 0; i < n; i++) {
    let maxValue = 0, maxRow = 0;
    for (let j = i; j < aug.length; j++) {
      let val = Math.abs(A[j][i]);
      if (val > maxValue) {
        maxValue = val;
        maxRow = j;
      }
    }
    if (maxValue === 0) throw new Error('Singular Matrix');
    let row = aug.splice(maxRow, 1)[0]
    row = [...(new Array(i).fill(0)), 1, ...row.slice(i + 1).map(e => e / row[i])];
    aug.splice(i, 0, row);
    for (let j = 0; j < aug.length; j++)
      if (i !== j) aug[j] = aug[j].map((e, k) => e - aug[j][i] * aug[i][k]);
  }

  for (let i = n; i < aug.length; i++)
    for (let j = n; j < aug[i].length; j++)
      if (Math.abs(aug[i][j]) > 1e-7) throw new Error('No Solution');

  const X = aug.slice(0, n).map(row => row.slice(n).map(e => Math.round(e * 1e3) / 1e3));
  return bIsVec ? tMat(X)[0] : X;
};

const invMat = M.invMat = A => linSolve(A, A.map((r, i) => r.map((c, j) => (i === j) - 0)));

const MatMul = M.MatMul = (A, B) => {
  const bIsVec = !Array.isArray(B[0]);
  B = bIsVec ? [B] : tMat(B);
  const C = A.map(r => B.map(c => sum(conv(r, c))));
  return bIsVec ? tMat(C)[0] : C
}

return M;
