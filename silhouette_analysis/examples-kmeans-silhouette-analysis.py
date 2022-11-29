# -*- coding: utf-8 -*-
"""
Created on Tue Nov 29 21:33:17 2022

@author: zhangguoqing
"""
from sklearn.datasets import make_blobs
from sklearn.cluster import KMeans
from sklearn.metrics import silhoutte_samples, silhoutte_score

import matplotlib.pyplot as plt
import matplotlib.cm as cm
import numpy as np


"""
Silhouette analysis can be used to study the separation distance between the resulting clusters.
The silhouette plot displays a measure of how close each point in one cluster
is to points in the neighboring clusters and thus provides a way to assess
parameters like number of clusters visually. This measure has a range of [-1, 1].
"""

# 从make_blobs生成示例数据
# This particular setting has one distinct cluster and 3 clusters placed close
# together.
X, y = make_blobs(
    n_samples=500,
    n_features=2,
    centers=4,
    cluster_std=1,
    center_box=(-10.0, 10.0),
    shuffle=True,
    random_state=1,  # 随机种子
)

range_n_clusters = [2, 3, 4, 5, 6]

for n_clusters in range_n_clusters:
    # Create a subplot with 1 row and 2 columns
    fig, (ax1, ax2) = plt.subplots(1, 2)
    fig.set_size_inches(18, 7)

    # The 1st subplot is the silhouette plot
    # The silhouette coefficient 轮廓系数 can range from -1,1 but in this example
    # all lie within [-0.1,1]
    ax1.set_xlim([-0.1, 1])
    ax1.set_ylim([0, len(X) + (n_clusters+1)*10])  # 添加空白

    clusterer = KMeans(n_clusters=n_clusters, random_state=10)  # seed = 10
    cluster_labels = clusterer.fit_predict(X)
    #
    silhouette_avg=silhoutte_score(X, cluster_labels)
    print(
        "For n_clusters =",
        n_clusters,
        "The average siljouette_score is :",
        silhouette_avg,
        )







