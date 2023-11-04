library(vegan)

#############################
##第 1 种模式，输入距离矩阵排序
#读取 OTU 丰度表
otu <- read.delim('otu_table.txt', row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
otu <- data.frame(t(otu))

#根据物种组成计算样方距离，如 Bray-curtis 距离，详情 ?vegdist
bray_dis <- vegdist(otu, method = 'bray')	#结果以 dist 数据类型存储

#输出距离矩阵
#write.table(as.matrix(bray_dis), 'bray_distance.txt', sep = '\t', col.names = NA, quote = FALSE)

#或者读取已经准备好的距离矩阵文件，如 Bray-curtis 距离，排序
dis <- read.delim('bray_distance.txt', row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
bray_dis <- as.dist(dis)	#转为 dist 数据类型

#NMDS 排序，定义 2 个维度，详情 ?metaMDS
nmds_dis <- metaMDS(bray_dis, k = 2)

#应力函数值，一般不大于 0.2 为合理
nmds_dis$stress
#样方得分
nmds_dis_site <- data.frame(nmds_dis$points)
#write.table(nmds_dis_site, 'nmds_dis_site.txt', sep = '\t', col.names = NA, quote = FALSE)

#由于物种变量在距离矩阵的计算过程中丢失，因此若想补充物种变量
#物种变量可通过丰度加权平方被动添加至排序图中，详情 ?wascores
nmds_dis_species <- wascores(nmds_dis$points, otu)
#write.table(nmds_dis_species, 'nmds_dis_species.txt', sep = '\t', col.names = NA, quote = FALSE)

#NMDS 评估，拟合 R2 越大越合理；气泡图越小越合理
par(mfrow = c(1, 2))
stressplot(nmds_dis, main = '第1种模式，Shepard 图')
gof <- goodness(nmds_dis)
plot(nmds_dis,type = 'text', main = '第1种模式，拟合度')
points(nmds_dis, display = 'site', cex = gof * 100, col = 'red')

#############################
##第 2 种模式，直接输入 OTU 丰度表，在函数中指定距离参数排序
otu <- read.delim('otu_table.txt', row.names = 1, sep = '\t', stringsAsFactors = FALSE, check.names = FALSE)
otu <- data.frame(t(otu))

#NMDS 排序，定义 2 个维度，详情 ?metaMDS
nmds_otu <- metaMDS(otu, distance = 'bray', k = 2)

#应力函数值，一般不大于 0.2 为合理
nmds_otu$stress
#样方得分
nmds_otu_site <- data.frame(nmds_otu$points)
#write.table(nmds_otu_site, 'nmds_otu_site.txt', sep = '\t', col.names = NA, quote = FALSE)
#物种得分，这种模式下可直接计算出物种得分，具体怎么算出来的，问作者吧……
nmds_otu_species <- data.frame(nmds_otu$species)
#write.table(nmds_otu_species, 'nmds_otu_species.txt', sep = '\t', col.names = NA, quote = FALSE)

#NMDS 评估，拟合 R2 越大越合理；气泡图越小越合理
par(mfrow = c(1, 2))
stressplot(nmds_otu, main = '第2种模式，Shepard 图')
gof <- goodness(nmds_otu)
plot(nmds_otu, type = 'text', display = 'sites', main = '第2种模式，拟合度')
points(nmds_otu, display = 'site', cex = gof * 100, col = 'red')

#############################
#ordiplot() 作图展示，比较两种方法的不同
par(mfrow = c(2, 2))

#输入距离矩阵直接排序，仅样方
ordiplot(nmds_dis, type = 'none', main = paste('第1种模式，仅样方，Stress =', round(nmds_dis$stress, 4)))
points(nmds_dis, pch = 19, cex = 0.7, col = c(rep('red', 12), rep('orange', 12), rep('green3', 12)))

#输入距离矩阵直接排序，样方 + 被动物种投影
ordiplot(nmds_dis, type = 'none', main = paste('第1种模式，样方+物种，Stress =', round(nmds_dis$stress, 4)))
points(nmds_dis_species, pch = 3, cex = 0.5, col = 'gray')
points(nmds_dis, pch = 19, cex = 0.7, col = c(rep('red', 12), rep('orange', 12), rep('green3', 12)))

#输入原始物种丰度表并指定距离类型的排序，仅样方
ordiplot(nmds_otu, type = 'none', display = 'site', main = paste('第2种模式，仅样方，Stress =', round(nmds_otu$stress, 4)))
points(nmds_otu, display = 'site', pch = 19, cex = 0.7, col = c(rep('red', 12), rep('orange', 12), rep('green3', 12)))

#输入原始物种丰度表并指定距离类型的排序，样方 +物种
ordiplot(nmds_otu, type = 'none', main = paste('第2种模式，样方+物种，Stress =', round(nmds_otu$stress, 4)))
points(nmds_otu, display = 'sp', pch = 3, cex = 0.5, col = 'gray')
points(nmds_otu, display = 'site', pch = 19, cex = 0.7, col = c(rep('red', 12), rep('orange', 12), rep('green3', 12)))

#别问我哪种更好，根据经验：
#第 2 种方法一般更能反映差异，但仅能指定特定的距离类型；对于其它 vegan 中没有的距离类型，应用起来倒不是不行，但必须修改原函数，就比较复杂了
#然而就算法而言第 1 种更符合 NMDS 定义，而且距离测度适用广泛，只要提供现有的距离矩阵即可
#所以现在是真的不知道了......还请大家看着自己琢磨吧.......

##再拿 ggplot2 基于导出的坐标作个图吧，按第 1 种模式的结果来
library(ggplot2)

#物种太多，就选代表性的展示，比方说 top10 丰度物种
abundance <- apply(otu, 2, sum)
abundance_top10 <- names(abundance[order(abundance, decreasing = TRUE)][1:10])

species_top10 <- data.frame(nmds_dis_species[abundance_top10,1:2])
species_top10$name <- rownames(species_top10)

#添加分组信息
nmds_dis_site$name <- rownames(nmds_dis_site)
nmds_dis_site$group <- c(rep('A', 12), rep('B', 12), rep('C', 12))

p <- ggplot(data = nmds_dis_site, aes(MDS1, MDS2)) +
geom_point(aes(color = group)) +
stat_ellipse(aes(fill = group), geom = 'polygon', level = 0.95, alpha = 0.1, show.legend = FALSE) +	#添加置信椭圆，注意不是聚类
scale_color_manual(values = c('red3', 'orange3', 'green3')) +
scale_fill_manual(values = c('red', 'orange', 'green3')) +
theme(panel.grid.major = element_line(color = 'gray', size = 0.2), panel.background = element_rect(color = 'black', fill = 'transparent'), 
	plot.title = element_text(hjust = 0.5), legend.position = 'none') +
geom_vline(xintercept = 0, color = 'gray', size = 0.5) +
geom_hline(yintercept = 0, color = 'gray', size = 0.5) +
geom_text(data = species_top10, aes(label = name), color = 'blue', size = 3) +	#添加 top10 丰度物种标签
labs(x = 'NMDS1', y = 'NMDS1', title = 'NMDS（带top10丰度物种投影）') +
annotate('text', label = paste('Stress =', round(nmds_dis$stress, 4)), x = 0.35, y = 0.3, size = 4, colour = 'black') +	#标注应力函数值
annotate('text', label = 'A', x = -0.27, y = 0.08, size = 5, colour = 'red3') +
annotate('text', label = 'B', x = -0.03, y = 0.11, size = 5, colour = 'orange3') +
annotate('text', label = 'C', x = 0.13, y = -0.15, size = 5, colour = 'green3')

p

#ggsave('NMDS_dis.pdf', p, width = 5.5, height = 5.5)
ggsave('NMDS_dis.png', p, width = 5.5, height = 5.5)
