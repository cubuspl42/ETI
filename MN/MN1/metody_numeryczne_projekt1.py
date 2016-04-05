import plotly.offline as pl
import plotly.graph_objs as go
import numpy as np
import sh

from os import path
from itertools import product

pl.init_notebook_mode()

dir = '/Users/kuba/Code/ETI/MN/MN1'

def sin(fn, tp, n, x):
    cmd = sh.Command("sh")
    out = str(cmd(path.join(dir, 'sin'), fn, tp, n, x))
    return float(out)

X = np.arange(0.1, np.pi/2, 0.05)

N = np.arange(1, 16)

def plot_re_x(n):
    
    def g(a):
        fn, tp = a
        return go.Scatter(
            x = X,
            y = [sin(fn, tp, n, x) for x in X],
            mode = 'lines+markers',
            name = fn + ' (' + tp + ')'
        )
    
    data = list(map(g, product(['sin1_ltr', 'sin1_rtl', 'sin2'], ['float', 'double', 'longdouble'])))
    
    layout = go.Layout(
        title='Błąd względny (%d wyrazów)' % (n,),
        width=960,
        height=720,
        #hovermode='closest',
        xaxis=dict(title='x',),
        yaxis=dict(title='Błąd względny', type='log', autorange=True),
    )
    
    fig = go.Figure(data=data, layout=layout)
    
    pl.iplot(fig, show_link=False)

def plot_re_n(x):
    
    def g(a):
        fn, tp = a
        return go.Scatter(
            x = N,
            y = [sin(fn, tp, n, x) for n in N],
            mode = 'lines+markers',
            name = fn + ' (' + tp + ')'
        )
    
    data = list(map(g, product(['sin1_ltr', 'sin1_rtl', 'sin2'], ['float', 'double', 'longdouble'])))
    
    layout = go.Layout(
        title='Błąd względny (x = %f)' % (x,),
        width=960,
        height=720,
        #hovermode='closest',
        xaxis=dict(
            title='Liczba wyrazów szeregu Taylora',
            #type='log',
            #ticklen=5,
            #zeroline=False,
            #gridwidth=2,
        ),
        yaxis=dict(
            title='Błąd względny',
            type='log',
            autorange=True
            #ticklen=5,
            #gridwidth=2,
        ),
    )
    
    fig = go.Figure(data=data, layout=layout)
    
    pl.iplot(fig, show_link=False)

def plot_re_x_lin(tp, n):
    
    def g(fn):
        return go.Scatter(
            x = X,
            y = [sin(fn, tp, n, x) for x in X],
            mode = 'lines+markers',
            name = fn + ' (' + tp + ')'
        )
    
    data = list(map(g, ['sin1_ltr', 'sin1_rtl', 'sin2']))
    
    layout = go.Layout(
        title='Błąd względny (%s, %d wyrazów)' % (tp, n),
        width=960,
        height=720,
        xaxis=dict(title='x'),
        yaxis=dict(title='Błąd względny'),
    )
    
    fig = go.Figure(data=data, layout=layout)
    
    # pl.plot(fig, output_type='div', show_link=False,  link_text='')
    pl.iplot(fig, show_link=False)

   