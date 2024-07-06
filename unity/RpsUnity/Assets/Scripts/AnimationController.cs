using FlutterUnityIntegration;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;


public class AnimationController : MonoBehaviour
{
    public Animator animator;
    public string clipName; 
    public ShakeImage shakeImage;
    private bool animationEnded = false;
    public GameObject loaderImage,handImage;
    public bool sendAnimationEndedMessage = false;


    void Update()
    {
        CheckAnimationClip();
    }

    private void OnAnimationEnd()
    {
        RefreshHandSprite();
        if (sendAnimationEndedMessage) {
            UnityMessageManager.Instance.SendMessageToFlutter("animation finished");
        }
    }

    private void RefreshHandSprite()
    {
        shakeImage.Animate();
        if (spriteToLoad != null)
        {
            handImage.SetActive(true);
            loaderImage.SetActive(false);
            handImage.GetComponent<Image>().sprite = spriteToLoad;
            spriteToLoad = null;
        }
        else
        {
            Debug.Log("No sprite to load.");
        }

    }

    private void CheckAnimationClip() {

        if (animator == null)
        {
            Debug.LogWarning("Animator component is not assigned.");
            return;
        }

        AnimatorClipInfo[] clipInfos = animator.GetCurrentAnimatorClipInfo(0);

        if (clipInfos.Length > 0)
        {
            AnimatorClipInfo clipInfo = clipInfos[0];
            if (clipInfo.clip.name == clipName)
            {
                if (animator.GetCurrentAnimatorStateInfo(0).normalizedTime >= .95f && !animator.IsInTransition(0))
                {
                    if (!animationEnded)
                    {
                        animationEnded = true;
                        Debug.Log(clipName + " has ended.");
                        OnAnimationEnd();
                    }
                }
                else
                {
                    animationEnded = false; 
                }
            }
        }
    }



    private Sprite spriteToLoad;
    public void ReplaceHandImage(Sprite sprite) {
        loaderImage.SetActive(true);
        handImage.SetActive(false);
        spriteToLoad = sprite;
        animator.SetTrigger("play-anim");
    }
}
