#! /usr/bin/python3

# plots the throughput versus n delay 
import matplotlib.pyplot as plt

nodes_list = [1, 2, 4, 6, 8, 10]
throughput = []

for nodes in nodes_list:
    total = 0
    for node in range(nodes):
        fname = 'q2/'+str(nodes)+'/q2_q_b'+str(node)+'.tr'
        with open(fname, 'r') as f:
            for line in f:
                parts = line.split(' ')
                if parts[0] == 'r':
                    total = total + int(parts[5])
    throughput.append((total*8)/1000000)

plt.scatter(nodes_list, throughput)
plt.title('Throughput vrs. Nodes')
plt.xlabel('# Nodes')
plt.ylabel('Throughput (Mb)')
plt.show()

