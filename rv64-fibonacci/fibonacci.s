        		.global fibonacci
        		.text

fibonacci:
				# write your code here
				li a1, 1 # a = 1
				li a2, 1 # b = 1
				li a3, 2 # i = 2
				# do
1:	  			add a4, a1, a2
				mv a1, a2
				mv a2, a4
				addi a3, a3, 1
				blt a3, a0, 1b
				mv a0, a2
				ret
				
