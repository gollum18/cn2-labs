#! /usr/bin/python3

# plots the throughput versus link delay 
import matplotlib.pyplot as plt

# setup the delay windows for the entire simulation
#   the components for each window are: (begin_time, end_time, delay)
windows = [(1.75, 3.5, 2), (3.5, 5.25, 4), (5.25, 7.0, 6), 
        (7.0, 8.75, 8), (8.75, 10.5, 10), (10.5, 12.25, 12), 
        (12.25, 14.0, 14), (14.0, 15.75, 16), (15.75, 17.5, 18), 
        (17.5, 20.0, 20)]

# store the total bits received in the windows
bytes_recvd = dict()
for window in windows:
    bytes_recvd[(window[0], window[1])] = 0

# read in the data for the simulation
with open('q1_a1_p.tr', 'r') as f:
    for line in f:
        parts = line.split(' ')
        # we only care about ones that were received
        if parts[0] != 'r':
            continue
        time = float(parts[1])
        index = 0
        for window in windows:
            if time >= window[0] and time < window[1]:
                break
            index = index + 1
        key = (windows[index][0], windows[index][1])
        if key in bytes_recvd:
            bytes_recvd[key] = bytes_recvd[key] + int(parts[5])
        else:
            bytes_recvd[key] = int(parts[5])

y = [(v*8)/1000000 for k, v in bytes_recvd.items()]
x = [window[2] for window in windows]

print(x)
print(y)

plt.scatter(x, y)
plt.title('Throughput versus Link Delay')
plt.xlabel('Link Delay (ms)')
plt.ylabel('Throughput (Mb/1.75s')
plt.show()

