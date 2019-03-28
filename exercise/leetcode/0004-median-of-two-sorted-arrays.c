// https://leetcode.com/problems/median-of-two-sorted-arrays/
double findMedianSortedArrays(int* nums1, int nums1Size, int* nums2, int nums2Size) {
    // Swap the two arrays to make 1 stands for the shorter one.
    int size, *nums;
    if (nums1Size > nums2Size) {
        size = nums1Size;
        nums1Size = nums2Size;
        nums2Size = size;
        nums = nums1;
        nums1 = nums2;
        nums2 = nums;
    }

    // Binary search for the point in array one
    // and the corresponding point in array two
    // which divide the two arrays into two parts
    // with the same amount of elements
    int left = 0, right = nums1Size;
    int half = (nums1Size + nums2Size + 1) / 2;
    int mid1, mid2;
    while (left <= right) {
        mid1 = (left + right) / 2;
        mid2 = half - mid1;
        if (mid1 < nums1Size && nums1[mid1] < nums2[mid2 - 1])
            left = mid1 + 1;
        else if (mid1 > 0 && nums1[mid1 - 1] > nums2[mid2])
            right = mid1 - 1;
        else
            break;
    }

    // Calculate the median
    int left_max;
    if (mid1 == 0)
        left_max = nums2[mid2 - 1];
    else if (mid2 == 0 || nums1[mid1 - 1] > nums2[mid2 - 1])
        left_max = nums1[mid1 - 1];
    else
        left_max = nums2[mid2 - 1];
    if ((nums1Size + nums2Size) % 2 == 1)
        return left_max;
    int right_min;
    if (mid1 == nums1Size)
        right_min = nums2[mid2];
    else if (mid2 == nums2Size || nums1[mid1] < nums2[mid2])
        right_min = nums1[mid1];
    else
        right_min = nums2[mid2];
    return (left_max + right_min) / 2.0;
}
