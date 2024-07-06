using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ShakeImage : MonoBehaviour
{
    public Image targetImage; 
    public float duration = 1f;
    public Vector3 strength = new Vector3(10f, 10f, 0f); 
    public int vibrato = 10; 
    public float randomness = 90f; 

    public void Animate()
    {
        if (targetImage == null)
        {
            Debug.LogWarning("Target Image is not assigned.");
            return;
        }

        RectTransform rectTransform = targetImage.GetComponent<RectTransform>();
        rectTransform.DOShakeAnchorPos(duration, strength, vibrato, randomness);
    }
}
