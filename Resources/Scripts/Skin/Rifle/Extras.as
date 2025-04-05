/*
 Copyright (c) 2013 Paratrooper
 */

namespace spades {
	Matrix4 CreateEulerAnglesMatrix( Vector3 angles ) {
		Matrix4 mat = CreateRotateMatrix( Vector3(1.f, 0.f, 0.f), angles.x );
		mat = CreateRotateMatrix( Vector3(0.f, 1.f, 0.f), angles.y ) * mat;
		mat = CreateRotateMatrix( Vector3(0.f, 0.f, 1.f), angles.z ) * mat;
		
		return mat;
	}

	class MagazineParticle {
		private Matrix4 originalMatrix;
		private Vector3 worldVelocity;
		private Vector3 worldAcceleration;
		private Vector3 localEulerAngularVelocity; // don't use Euler angles, blah blah blah
		
		Matrix4 OriginalMatrix {
			set { originalMatrix = value; }
			get { return originalMatrix; }
		}
		
		Vector3 WorldVelocity {
			set { worldVelocity = value; }
			get { return worldVelocity; }
		}
		
		Vector3 WorldAcceleration {
			set { worldAcceleration = value; }
			get { return worldAcceleration; }
		}
		
		Vector3 LocalEulerAngularVelocity {
			set { localEulerAngularVelocity = value; }
			get { return localEulerAngularVelocity; }
		}
		
		private Renderer@ renderer;
		private Model@ objectModel;
		
		MagazineParticle() {};
		MagazineParticle(Renderer@ renderer) {
			@this.renderer = renderer;
			@objectModel = renderer.RegisterModel
				("Models/Weapons/Rifle/Magazine.kv6");
				
		}
		
		private float lifetime = 4.f;
		private float currentLife = 0.f;
		private bool isDead = true;
		
		bool IsDead {
			set { isDead = value; }
			get { return isDead; }
		}
		
		void Start(Matrix4 pos, Vector3 velocity, Vector3 acceleration, Vector3 angularv) {
			originalMatrix = pos;
			worldVelocity = velocity;
			worldAcceleration = acceleration;
			localEulerAngularVelocity = angularv;
			currentLife = 0.f;
			isDead = false;
		}
		
		void Update(float dt) {
			if (!isDead) {
				Matrix4 currentMatrix;
				currentMatrix = (CreateTranslateMatrix(worldVelocity*currentLife + worldAcceleration*currentLife*currentLife*0.5f)) * originalMatrix;
				currentMatrix = currentMatrix * CreateEulerAnglesMatrix(localEulerAngularVelocity * currentLife);
				currentMatrix = currentMatrix * CreateTranslateMatrix(0.f, 0.f, -10.f);
			
				ModelRenderParam param;
				param.matrix = currentMatrix;
				param.depthHack = false;
				renderer.AddModel(objectModel, param);
				
				currentLife += dt;
				if (currentLife > lifetime) {
					isDead = true;
				}
				
				// don't let it fall off the map
				if (currentMatrix.GetOrigin().z > 63.f) {
					isDead = true;
				} 
			}
		}
	}
	
	// select easing functions
	float quadraticIn(float alpha) {
		return (alpha*alpha);
	}
	
	float quadraticOut(float alpha) {
		return -(alpha * (alpha-2));
	}
	
	float quadraticInOut(float alpha) {
		if(alpha < 0.5f)
		{
			return 2.f*alpha*alpha;
		}
		else
		{
			return (-2.f*alpha*alpha) + (4.f*alpha) - 1.f;
		}
	}
	
	float cubicIn(float alpha) {
		return (alpha*alpha*alpha);
	}
	
	float cubicOut(float alpha) {
		alpha = alpha-1;
		return (alpha*alpha*alpha + 1);
	}
	
	// clamp val between a and b
	// a must be less than b
	float clamp(float val, float a, float b) {
		if (val < a) {
			return a;
		} else if (val > b) {
			return b;
		} else {
			return val;
		}
	}
}
