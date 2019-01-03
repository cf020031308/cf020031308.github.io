double findMedianSortedArrays(int* nums1, int nums1Size, int* nums2, int nums2Size) {
    int left1 = 0, right1 = nums1Size - 1;
    int left2 = 0, right2 = nums2Size - 1;
    int mid1, mid2;
    
    int odd = (nums1Size + nums2Size) % 2 == 1;
    if (nums1Size > nums2Size) {
        left1 = (nums1Size - nums2Size) / 2;
        right1 -= left1;
        if (nums2Size == 0) return (nums1[left1] + nums1[right1]) / 2.0;
        if (odd) right1 -= 1;
    } else {
        left2 = (nums2Size - nums1Size) / 2;
        right2 -= left2;
        if (nums1Size == 0) return (nums2[left2] + nums2[right2]) / 2.0;
        if (odd) right2 -= 1;
    }
    
    while (left1 != right1 || left2 != right2) {
        mid1 = (left1 + right1 + 1) / 2;
        mid2 = (left2 + right2 + 1) / 2;
        if (nums1[mid1] < nums2[mid2]) {
            left1 = (left1 + right1) / 2;
            right2 = mid2;
        } else {
            right1 = mid1;
            left2 = (left2 + right2) / 2;
        }
    }
    
    if (nums1[left1] < nums2[left2]) {
        if (odd) return nums2[left2];
        if (left1 < nums1Size - 1 && nums1[left1 + 1] < nums2[left2])
            return (nums1[left1] + nums1[left1 + 1]) / 2.0;
    } else {
        if (odd) return nums1[left1];
        if (left2 < nums2Size - 1 && nums2[left2 + 1] < nums1[left1])
            return (nums2[left2] + nums2[left2 + 1]) / 2.0;
    }
    return (nums1[left1] + nums2[left2]) / 2.0;
}
