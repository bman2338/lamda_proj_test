using UnityEngine;
using System.Collections;

public class Player : MonoBehaviour {
	bool applyGrav = true;
	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		if(applyGrav){
			//this.transform.Translate(new Vector3(0f,-.05f,0f));
		}
		if(Input.GetKeyDown("a")){
			Debug.Log("Hey!");
			this.rigidbody.velocity = new Vector3(-1f,0f,0f);
		}
		if(Input.GetKeyDown("d")){
			this.rigidbody.velocity = new Vector3(1f,0f,0f);
		}
		if(Input.GetKeyDown("w")){
			this.rigidbody.AddForce(new Vector3(0f,.05f,0f),ForceMode.Impulse);	
		}
	}
	void OnTriggerEnter(Collider collision) {
	if(collision != null){
			applyGrav = false;
	 }
	}
}
