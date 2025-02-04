from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///mydatabase.db'
db = SQLAlchemy(app)

class Patient(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    age = db.Column(db.Integer, nullable=False)

class Medcin(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    specialty = db.Column(db.String(80), nullable=False)

class Medoc(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    dosage = db.Column(db.String(80), nullable=False)

class Posologie(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patient.id'), nullable=False)
    medoc_id = db.Column(db.Integer, db.ForeignKey('medoc.id'), nullable=False)
    medcin_id = db.Column(db.Integer, db.ForeignKey('medcin.id'), nullable=False)
    dosage = db.Column(db.String(80), nullable=False)
    frequency = db.Column(db.String(80), nullable=False)

    patient = db.relationship('Patient', backref=db.backref('posologies', lazy=True))
    medoc = db.relationship('Medoc', backref=db.backref('posologies', lazy=True))
    medcin = db.relationship('Medcin', backref=db.backref('posologies', lazy=True))

@app.route('/api/patients', methods=['GET'])
def get_patients():
    patients = Patient.query.all()
    return jsonify([{'id': patient.id, 'name': patient.name, 'age': patient.age} for patient in patients])

@app.route('/api/patients', methods=['POST'])
def add_patient():
    data = request.get_json()
    new_patient = Patient(name=data['name'], age=data['age'])
    db.session.add(new_patient)
    db.session.commit()
    return jsonify({'message': 'Patient added', 'patient': {'id': new_patient.id, 'name': new_patient.name, 'age': new_patient.age}})

if __name__ == '__main__':
    db.create_all()
    app.run(debug=True)