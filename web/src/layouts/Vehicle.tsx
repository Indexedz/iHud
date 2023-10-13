import React, { useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Transition } from '@headlessui/react';
import useEvent from '../lib/hooks/useEvent';

interface Vehicle{
    seatbelt: boolean;
    speed: number;
    fuel: number;
    health: number;
    address: string;
}

interface VehicleUpdate {
    seatbelt?: boolean;
    speed?: number;
    fuel?: number;
    health?: number;
    address?: string;
}

export default function Index() {
    const [visible, setVisible] = useState<boolean>(false);
    const [vehicleState, setVehicleState] = useState<Vehicle>({
        seatbelt: false,
        speed: 0.1,
        fuel: 0,
        health: 0,
        address: "Novelty",
    });

    useEvent("SetVisibleVehicle", setVisible);
    useEvent("UpdateVehicle", (update: VehicleUpdate) => {
        setVehicleState((prevState) => ({ ...prevState, ...update }));
    });

    const color = (val: number, reverse: boolean = false) => {
        const colours: [number, string][] = [
            [100, 'text-green-300 shadow-green-300'],
            [70, 'text-yellow-300 shadow-yellow-300'],
            [50, 'text-orange-300 shadow-orange-300'],
            [25, 'text-red-500 shadow-red-500']
        ];
        
        const selectedColor = reverse
            ? colours.find((color) => color[0] <= val)
            : colours.find((color) => color[0] >= val);
        
        return selectedColor ? selectedColor[1] : '';
    };

    return (
        <Transition
            appear
            show={visible}
            as={React.Fragment}
            enter='ease-out duration-300'
            enterFrom='opacity-0'
            enterTo='opacity-100'
            leave='ease-in duration-200'
            leaveFrom='opacity-100'
            leaveTo='opacity-0'
        >
            <div className='fixed bottom-4 inset-x-0 flex justify-center'>
                <div className='space-x-1'>
                    <div className='grid grid-cols-3 text-white'>
                        {/* Fuel */}
                        <div className='space-x-1 text-right mt-auto'>
                            <span className={`font-bold ${color(vehicleState.fuel)}`}>{vehicleState.fuel.toFixed(1)}</span>
                            <FontAwesomeIcon icon={['fas', "gas-pump"]} className='text-white my-auto' />
                        </div>

                        {/* Speed */}
                        <div className='flex justify-center flex-col'>
                            <div className={`text-center text-4xl ${color(vehicleState.speed/540*100, false)}`}>{vehicleState.speed.toFixed()}</div>
                            <div className='text-center text-sm'>KP/H</div>
                        </div>

                        {/* Seatbelt */}
                        <div className='space-x-1 text-left mt-auto'>
                            <FontAwesomeIcon icon={['fas', "user-slash"]} className='text-white my-auto' />
                            <span className={`font-bold drop-shadow ${vehicleState.seatbelt ? 'text-green-500 shadow-green-300' : 'text-red-500 shadow-red-300'}`}>
                                {vehicleState.seatbelt ? "ON" : "OFF"}
                            </span>
                        </div>
                    </div>

                    {/* Address */}
                    <div className='flex justify-center space-x-1 mt-1'>
                        <FontAwesomeIcon icon={['fas', "compass"]} className='text-white my-auto' />
                        <span className='text-white text-sm'>{vehicleState.address}</span>
                    </div>

                    {/* Health */}
                    <div className='flex gap-1'>
                        <div className='w-5'><FontAwesomeIcon icon={['fas', "car-crash"]} className='text-white my-auto' /></div>
                        <div className="rounded-full h-1.5 my-auto overflow-hidden w-64 bg-black bg-opacity-50">
                            <div className="bg-blue-600 h-full rounded-full" style={{
                                width: `${vehicleState.health}%`
                            }}></div>
                        </div>
                        <div className='w-5'>
                            <p className='text-white'><span>{vehicleState.health.toFixed(1)}</span>%</p>
                        </div>
                    </div>
                </div>
            </div>
        </Transition>
    );
}
