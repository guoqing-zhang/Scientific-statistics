# -8- coding:  utf-8 -*-

'''
Author: Guoqing Zhang
Mail: zhangguoqing84@westlake.edu.cn
'''

"""z检验是在方差已知且样本量较大的情况下，确定两个总体均值是否不同的统计检验。
ref: https://www.geeksforgeeks.org/how-to-perform-a-one-proportion-z-test-in-python/?ref=rp
"""

# Methods 1
# 使用给定公式计算单比例z检验，并将给定值放入公式并得到结果。
# z=(P-Po)/sqrt(Po(1-Po)/n

import math

P = 0.86
Po = 0.80
n = 100
a = (P-Po)
b = Po*(1-Po)/n
z = a/math.sqrt(b)
print(z)

# Methods2
将statsmodels.stats.proportion库导入到python编译器中，然后调用percents_ztest()函数，通过向函数中添加参数来简单地获得一个proportional Z-test。
# import library
from statsmodels.stats.proportion import proportions_ztest

# perform one proportion z-test
proportions_ztest(count=80, nobs=100, value=0.86)
'''
Output:
(-1.4999999999999984, 0.1336144025377165)
'''