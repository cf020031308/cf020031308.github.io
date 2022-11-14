# SDNE：深度图神经网络嵌入

复现如下

```python
import torch
import torch.nn as nn


def FC(din, dout):
    return gpu(nn.Sequential(
        nn.LayerNorm(din),
        nn.ReLU(),
        nn.Dropout(0.5),
        nn.Linear(din, dout)))


class SDNE(nn.Module):
    def __init__(self, din, hid):
        super(self.__class__, self).__init__()
        self.layers = nn.ModuleList()
        self.enc1 = gpu(nn.Linear(din, hid))
        self.enc2 = FC(hid, hid)
        self.dec1 = FC(hid, hid)
        self.dec2 = FC(hid, din)

    def forward(self, x):
        h = self.enc2(self.enc1(x))
        return h, self.dec2(self.dec1(h))

    def ws(self):
        return (
            self.enc1.weight.norm()
            + self.enc2[-1].weight.norm()
            + self.dec1[-1].weight.norm()
            + self.dec2[-1].weight.norm())


A = gpu(graph.adj()).float().to_dense()
src, dst = graph.edges()
sdne = SDNE(n_nodes, hid)
opt = torch.optim.Adam([*sdne.parameters()])
alpha, beta, gamma = 1e-5, 4, 1e-6
for _ in range(50):
	sdne.train()
	opt.zero_grad()
	F.mse_loss(sdne(A)[1], A).backward()
	opt.step()
for _ in range(200):
	sdne.train()
	opt.zero_grad()
	Y, X = sdne(A)
	loss = (
		alpha * (Y[src] - Y[dst]).norm(dim=1).sum()
		+ ((A - X) * (A * beta + 1)).norm()
		+ gamma * sdne.ws())
	loss.backward()
	opt.step()
with torch.no_grad():
    sdne.eval()
    emb = sdne(A)[0]
```
