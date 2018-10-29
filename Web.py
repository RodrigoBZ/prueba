import webbrowser
import time

total_break=3
break_count=0

print("this program started on "+ time.ctime())
while(break_count < total_break):
    time.sleep(5)
    webbrowser.open("https://www.youtube.com/watch?v=56WBK4ZK_cw", new=2)   
    break_count=break_count+1
