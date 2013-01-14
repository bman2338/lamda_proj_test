using UnityEngine;
using System.Collections;

public class NewBehaviourScript : MonoBehaviour {
	public Transform brick;
	public Transform lightSquare;
	public Transform platform;
	public Transform player;
	private Vector3 TRANSLATION_UNIT = new Vector3(0f,.05f,0f);
	// Use this for initialization
	void Start () {
	for (float y = 0; y < 25; y = y + 1.15f) {
		for (float x = 0; x < 20; x= x + 1.15f) {
			Instantiate(brick, new Vector3(x, y, 15.0f), Quaternion.identity);
		}
		if((int)(y % 5) == 0){
			Instantiate(lightSquare, new Vector3(10, y, 9.0f), Quaternion.identity);
		}
	}
	
		
	//side
	
	for (float z = 0; z < 20; z = z + 1.15f) {
		for (float x = 0; x < 25; x= x + 1.15f) {
			Instantiate(brick, new Vector3(20, x, z), Quaternion.identity);
		}
		if((int)(z % 5) == 0){
			Instantiate(lightSquare, new Vector3(19, 5, z), Quaternion.identity);
			Instantiate(lightSquare, new Vector3(19, 15, z), Quaternion.identity);
		}
	}
	//side

	for (float z = 0; z < 20; z = z + 1.15f) {
		for (float x = 0; x < 25; x= x + 1.15f) {
			Instantiate(brick, new Vector3(0, x, z), Quaternion.identity);
		}
		if((int)(z % 5) == 0){
			Instantiate(lightSquare, new Vector3(1, 5, z), Quaternion.identity);
			Instantiate(lightSquare, new Vector3(1, 15, z), Quaternion.identity);
		}
	}
	Instantiate(platform,new Vector3(5f,5f,7f), Quaternion.identity);
	Instantiate(platform,new Vector3(10f,7f,7f), Quaternion.identity);
	Instantiate(platform,new Vector3(15f,9f,7f), Quaternion.identity);
	
		
	Instantiate(player,new Vector3(6f,7f,7f),Quaternion.identity);
	Physics.gravity = new Vector3(0f,-3.81f,0f);
	}
	// Update is called once per frame
	void Update () {
		Camera camera = Camera.mainCamera;
		camera.transform.Translate(TRANSLATION_UNIT);
	}
}
