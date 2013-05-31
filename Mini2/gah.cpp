void findDisorder(int arr[], int n, int* p)
    {
        for (int k = 1; k < n; k++)
        {
            if (arr[k] < arr[k-1])
            {
                 p = arr + k;
                 return;
            }
        }
	p = NULL;
    }       
        
    int main()
    {
        int nums[6] = { 10, 20, 20, 40, 30, 50 };
        int* ptr;

        findDisorder(nums, 6, ptr);
	if (ptr == NULL)
	    cout << "The array is ordered" << endl;
	else
	{
            cout << "The disorder is at address " << ptr << endl;
            cout << "It's at index " << ptr - nums << endl;
            cout << "The item's value is " << *ptr << endl;
	}
    }