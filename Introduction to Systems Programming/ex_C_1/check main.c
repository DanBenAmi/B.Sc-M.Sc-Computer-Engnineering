int main(void){
	while(1){
		printf("Please choose assignment from 1 to 7\n");
		int ass;
		scanf("%d",&ass);
		switch(ass){
						case 1:
						{
							int arr[20]={3,6,4,1,1,2,2,4,7,6,2,2,5,5,6,8,9,4,2,1};
							histogramArray(arr,12);
							break;
						}
						case 2:
						{
							int arr[20] = {-2,8,23,-160,-100,-74,8,85,-47,-10,-0,12,-1,-2,-3,12,10,11,3,-12};
							printMaxPartAscending(arr,10);
							break;
						}
						case 3:
						{
							int ans = -1;
							int arr[5][10] = {{1,2,3,4,5,7,3,5,2,3},{7,4,2,1,3,8,4,6,7,9},{9,5,6,7,8,1,7,0,3,7}
							,{3,0,2,6,4,5,8,3,0,8},{1,3,8,9,2,1,4,2,7,5}};
							printf("Start!\n");
							ans = checkSaddleElement(arr,5,5);
							printf("%d\n",ans);
							break;
						}
						case 4:
						{
							int i,j;
							int arr[4][3] = {{1,2,3},{4,5,6},{7,8,9},{10,11,12}};
							for(i = 0; i < 4; i++){
								for(j = 0;j < 3;j++){
									printf("%d",arr[i][j]);
								}
								printf("\n");
							}
							rotateMatrix90(arr,3,3);
							for(i = 0; i < 4; i++){
								for(j = 0;j < 3;j++){
									printf("%d",arr[i][j]);
								}
								printf("\n");
							}
							break;
						}
						case 5:
						{
							char str[7] = "rotatel";
							rotateString(str,9,1);
							printf("%s\n",str);

							rotateString(str,9,2);
							printf("%s\n",str);
							break;
						}
						case 6:
						{
							char arr[4][8] = {{'c','t','c','m','s','c','a','r'},
							{'a','a','a','t','f','g','h','l'},{'g','a','r','j','e','x','f','b'},{'c','a','r','h','a','v','j','k'}};
							printf("%d\n",countWords(arr,4,8,"car"));
							break;
						}
						case 7:
						{
							char str[55]="Btwlzx Dqqes Eq|pj4 Tjhvqujs Iqoqjy bpg Eqfxtx Xcwwtt5";
							char str2[4] = "bcde";
							decipher(str);
							decipher(str2);
							printf("\n");
							break;
						}
						case 8:
						{
							findSimilarWords("Nanny have you any cheap peach ?");
							break;
						}
						case 0:
							return 1;
		}
	}
	return 1;
}
