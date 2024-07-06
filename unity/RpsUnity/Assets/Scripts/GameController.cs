using FlutterUnityIntegration;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEngine.UI;

public class GameController : MonoBehaviour
{
    public AnimationController playerController;
    public AnimationController computerController;


    public Sprite[] sprites;


    private void Start()
    {
        gameObject.AddComponent<UnityMessageManager>();
        Debug.Log("GameController: Started "+ gameObject.name);
        UnityMessageManager.Instance.SendMessageToFlutter("scene loaded");
    }


    public void UpdatePlayerImage(int index)
    {
        Debug.Log("Player Index: "+index);
        playerController.ReplaceHandImage(sprites[index]);
    }

    public void UpdateComputerImage(int index)
    {
        Debug.Log("Computer Index: " + index);
        computerController.ReplaceHandImage(sprites[index]);
    }

    public void UpdateHandImage(string message)
    {
        string[] data = message.Split(',');
        int playerIndex = int.Parse(data[0]);
        int computerIndex = int.Parse(data[1]);
        playerController.ReplaceHandImage(sprites[playerIndex]);
        computerController.ReplaceHandImage(sprites[computerIndex]);
    }
}

