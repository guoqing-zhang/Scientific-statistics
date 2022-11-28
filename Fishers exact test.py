# -*- coding: utf-8 -*-
'''
Author: Guoqing Zhang
mail: zhangguoqing84@westlake.edu.cn
'''

"""Fisher's exact test 是一种统计检验，它确定两个类别变量是否有非随机联系，或者我们可以说它用于检验两个类别变量是否有显著关系。
使用SciPy: fisher_exact()函数实现。
Syntax: scipy.stats.fisher_exact(table, alternative='two-sided')
"""

# importing packages
import scipy.stats as stats

# creating data
data = [[2, 8], [7, 3]]

# performing fishers exact test on the data
odd_ratio, p_value = stats.fisher_exact(data)
print('odd ratio is : ' + str(odd_ratio))
print('p_value is : ' + str(p_value))

'''
output:
odd ratio is : 0.10714285714285714
p_value is : 0.06977851869492728
'''